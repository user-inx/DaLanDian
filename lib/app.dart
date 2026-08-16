import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'shared/widgets/bottom_nav.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/screens/login_screen.dart';

class DaLanDianApp extends ConsumerWidget {
  const DaLanDianApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    // initial → Loading
    if (authState.isLoading) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '大蓝典',
        theme: AppTheme.light,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    // unauthenticated → LoginScreen
    if (authState.isUnauthenticated) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '大蓝典',
        theme: AppTheme.light,
        home: const LoginScreen(),
      );
    }

    // authenticated → BottomNav
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '大蓝典',
      theme: AppTheme.light,
      home: const BottomNav(),
    );
  }
}