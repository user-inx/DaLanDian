import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/auth_page.dart';
import '../../features/discover/discover_page.dart';
import '../../features/home/home_page.dart';
import '../../features/message/message_page.dart';
import '../../features/profile/profile_page.dart';
import '../../features/publish/publish_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/splash/splash_page.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.discover,
        name: 'discover',
        builder: (context, state) => const DiscoverPage(),
      ),
      GoRoute(
        path: AppRoutes.publish,
        name: 'publish',
        builder: (context, state) => const PublishPage(),
      ),
      GoRoute(
        path: AppRoutes.message,
        name: 'message',
        builder: (context, state) => const MessagePage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
