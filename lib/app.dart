import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'shared/widgets/bottom_nav.dart';

class DaLanDianApp extends StatelessWidget {
  const DaLanDianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '大蓝典',
      theme: AppTheme.light,
      home: const BottomNav(),
    );
  }
}