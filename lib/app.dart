import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/main/main_page.dart';

class DaLanDianApp extends StatelessWidget {
  const DaLanDianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '大蓝典',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainPage(),
    );
  }
}