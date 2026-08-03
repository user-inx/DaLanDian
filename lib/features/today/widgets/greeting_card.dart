import 'package:flutter/material.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _greeting(now.hour),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              _date(now),
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              '今天，也是改变人生的一天。',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _greeting(int hour) {
    if (hour >= 5 && hour < 12) {
      return '早上好 👋';
    }

    if (hour >= 12 && hour < 18) {
      return '下午好 ☀️';
    }

    if (hour >= 18 && hour < 24) {
      return '晚上好 🌙';
    }

    return '夜深了 🌌';
  }

  String _date(DateTime now) {
    const weeks = [
      '星期一',
      '星期二',
      '星期三',
      '星期四',
      '星期五',
      '星期六',
      '星期日',
    ];

    return '${now.year}年${now.month}月${now.day}日 ${weeks[now.weekday - 1]}';
  }
}