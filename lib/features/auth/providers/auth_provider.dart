import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

/// Auth 状态枚举
enum AuthStatus {
  initial,       // 初始状态，正在加载
  authenticated, // 已登录
  unauthenticated, // 未登录
}

/// Auth 状态类
class AuthState {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  bool get isLoading => status == AuthStatus.initial;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
}

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _init();
  }

  final SupabaseService _supabase = SupabaseService();

  void _init() {
    // 1. 检查当前已有 Session
    _checkCurrentSession();

    // 2. 监听 Auth 状态变化
    // ✅ 关键：使用 gotrue.AuthState 明确类型
    _supabase.onAuthStateChange.listen((authState) {
      final session = authState.session;
      final user = session?.user;
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          clearError: true,
        );
      }
    });
  }

  void _checkCurrentSession() {
    final user = _supabase.currentUser;
    if (user != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        clearError: true,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.initial,
      clearError: true,
    );

    try {
      final response = await _supabase.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      final session = response.session;

      if (user != null && session != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        );
      } else if (user != null && session == null) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          errorMessage: '注册成功！请检查邮箱进行验证。',
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          errorMessage: '注册失败，请稍后重试。',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        errorMessage: _getAuthErrorMessage(e.message),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        errorMessage: '注册失败，请稍后重试。',
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      status: AuthStatus.initial,
      clearError: true,
    );

    try {
      final response = await _supabase.signIn(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          clearError: true,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearUser: true,
          errorMessage: '登录失败，请检查邮箱和密码。',
        );
      }
    } on AuthException catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        errorMessage: _getAuthErrorMessage(e.message),
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        errorMessage: '登录失败，请稍后重试。',
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.signOut();
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        clearError: true,
      );
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  String _getAuthErrorMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials') ||
        lower.contains('invalid credentials')) {
      return '邮箱或密码错误，请重新输入。';
    }
    if (lower.contains('email not confirmed')) {
      return '请先验证邮箱后再登录。';
    }
    if (lower.contains('user already registered') ||
        lower.contains('already registered')) {
      return '该邮箱已被注册，请直接登录。';
    }
    if (lower.contains('password')) {
      return '密码至少需要6位。';
    }
    if (lower.contains('network') || lower.contains('connection')) {
      return '网络连接失败，请检查网络后重试。';
    }
    return '操作失败，请稍后重试。';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);