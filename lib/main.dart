import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/supabase_service.dart';

void main() async {
  // 1. 确保 Flutter 引擎已初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 2. 初始化 Supabase
  await SupabaseService().init();

  // 3. 启动应用
  runApp(
    const ProviderScope(
      child: DaLanDianApp(),
    ),
  );
}