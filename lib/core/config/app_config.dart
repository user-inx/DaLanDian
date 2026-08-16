/// 应用全局配置
class AppConfig {
  AppConfig._();

  // ========================================
  // 原有配置（保留）
  // ========================================

  static const Duration splashDuration = Duration(seconds: 2);

  // ========================================
  // Supabase 配置（新增）
  // ========================================

  /// Supabase 项目 URL
  /// 在 Supabase Dashboard → Settings → API 中获取
  /// 注意：只需要基础 URL，不需要 /rest/v1/
  static const String supabaseUrl = 'https://wxdrcqxwglggetbylrmr.supabase.co';

  /// Supabase 匿名发布密钥（publishable key）
  static const String supabasePublishableKey =
      'sb_publishable_54WE-wspStJ2iQTFmTkOSQ_FnDT_HRT';
}