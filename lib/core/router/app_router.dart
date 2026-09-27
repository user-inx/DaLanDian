import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/shell/screens/app_shell_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const AppShellScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
    ],
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (authState.isLoading) {
        return null;
      }

      if (!isLoggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      }

      if (isLoggedIn && (isLoggingIn || isRegistering)) {
        return '/';
      }

      return null;
    },
  );

  ref.listen<AuthState>(
    authProvider,
    (_, _) {
      router.refresh();
    },
  );

  ref.onDispose(router.dispose);

  return router;
});