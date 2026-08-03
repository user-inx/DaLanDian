import 'package:flutter/material.dart';

class LifeCountdownCard extends StatelessWidget {
  const LifeCountdownCard({super.key});

  static const int _lifeExpectancy = 90;

  @override
  Widget build(BuildContext context) {
    // MVP：先写死出生日期
    // 后续改为 Supabase 用户资料
    final birthday = DateTime(1991, 1, 1);

    final today = DateTime.now();

    final endDate = DateTime(
      birthday.year + _lifeExpectancy,
      birthday.month,
      birthday.day,
    );

    final totalDays = endDate.difference(birthday).inDays;
    final remainingDays = endDate.difference(today).inDays;

    final progress =
        ((totalDays - remainingDays) / totalDays).clamp(0.0, 1.0);

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

            const Text(
              "⏳ 人生余额",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "假设寿命",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),

                Text(
                  "$_lifeExpectancy 岁",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "剩余时间",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                Text(
                  "$remainingDays 天",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xffFFF4E5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "今天结束以后，你的人生将只剩 ${remainingDays - 1} 天。",
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}