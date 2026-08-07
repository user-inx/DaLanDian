import 'package:flutter/material.dart';

/// 显示每日金句的卡片组件
class QuoteCard extends StatelessWidget {
  /// 每日金句内容
  static const String _dailyQuote =
      '今天做一点，未来轻松一点。';

  /// 构造参数
  const QuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          _dailyQuote,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey[700],
              ),
        ),
      ),
    );
  }
}