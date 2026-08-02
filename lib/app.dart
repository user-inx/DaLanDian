import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class DaLanDianApp extends StatelessWidget {
  const DaLanDianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: '大蓝典',

      theme: AppTheme.light,

      home: const Scaffold(
        body: Center(
          child: Text(
            '欢迎来到大蓝典',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}