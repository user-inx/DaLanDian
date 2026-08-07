import 'package:flutter/material.dart';

/// 显示 AI 教练鼓励语的卡片组件
class CoachCard extends StatelessWidget {
  /// AI 教练鼓励语
  static const String _coachMessage =
      '继续保持，你距离目标越来越近。';

  /// 构造参数
  const CoachCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.lightbulb_outlined,
              color: Colors.amber[700],
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _coachMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}