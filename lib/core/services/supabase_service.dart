import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabasePublishableKey,
    );

    _initialized = true;
  }

  SupabaseClient get client => Supabase.instance.client;

  // ========================================
  // ✅ Auth 方法（新增）
  // ========================================

  /// 注册新用户
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// 登录
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// 登出
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// 获取当前用户
  User? get currentUser => client.auth.currentUser;

  /// 获取当前会话
  Session? get currentSession => client.auth.currentSession;

  /// 监听 Auth 状态变化
  Stream<AuthState> get onAuthStateChange => client.auth.onAuthStateChange;
}