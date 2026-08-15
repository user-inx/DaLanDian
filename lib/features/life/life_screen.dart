import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/providers/user_profile_provider.dart';
import '../profile/edit_profile_screen.dart';

class LifeScreen extends ConsumerStatefulWidget {
  const LifeScreen({super.key});

  @override
  ConsumerState<LifeScreen> createState() => _LifeScreenState();
}

class _LifeScreenState extends ConsumerState<LifeScreen> {
  late List<Map<String, dynamic>> _milestones;

  void _buildMilestones(int currentAge) {
    final now = currentAge;
    final List<Map<String, dynamic>> milestones = [];

    for (int age = ((now + 5) ~/ 10) * 10; age <= 90; age += 10) {
      milestones.add({
        'age': age,
        'title': _getMilestoneTitle(age),
        'icon': _getMilestoneIcon(age),
      });
    }

    _milestones = milestones;
  }

  String _getMilestoneTitle(int age) {
    if (age <= 30) return '探索期';
    if (age <= 40) return '积累期';
    if (age <= 50) return '爆发期';
    if (age <= 60) return '稳定期';
    if (age <= 70) return '收获期';
    if (age <= 80) return '传承期';
    return '圆满期';
  }

  IconData _getMilestoneIcon(int age) {
    if (age <= 30) return Icons.explore;
    if (age <= 40) return Icons.trending_up;
    if (age <= 50) return Icons.rocket_launch;
    if (age <= 60) return Icons.anchor;
    if (age <= 70) return Icons.grass;
    if (age <= 80) return Icons.family_restroom;
    return Icons.star;
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    _buildMilestones(profile.age);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '人生档案',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- 个人信息卡片 ----------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: const Color(0xFF1A73E8),
                    child: Text(
                      profile.name[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.age}岁 · ${profile.city}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '🎯 ${profile.goal}',
                          style: TextStyle(
                            fontSize: 13,
                            color: const Color(0xFF1A73E8),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 核心指标卡片 ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric(
                    icon: Icons.monetization_on,
                    iconColor: const Color(0xFF2E7D32),
                    label: '月收入',
                    value: '\$${profile.income}',
                  ),
                  _buildMetric(
                    icon: Icons.access_time,
                    iconColor: const Color(0xFFE65100),
                    label: '每日自由时间',
                    value: '${profile.dailyFreeHours}h',
                  ),
                  _buildMetric(
                    icon: Icons.timeline,
                    iconColor: const Color(0xFF1565C0),
                    label: '人生进度',
                    value:
                        '${(profile.lifeProgress * 100).toStringAsFixed(0)}%',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 人生节点预览 ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.timeline_outlined, size: 20, color: Color(0xFF1A73E8)),
                      SizedBox(width: 8),
                      Text(
                        '人生路线图预览',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _milestones.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final milestone = _milestones[index];
                        final isCurrent = milestone['age'] == profile.age;
                        final isPast = milestone['age'] < profile.age;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? const Color(0xFF1A73E8)
                                : isPast
                                    ? const Color(0xFFE8F0FE)
                                    : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCurrent
                                  ? const Color(0xFF1A73E8)
                                  : Colors.grey.shade200,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                milestone['icon'],
                                color: isCurrent
                                    ? Colors.white
                                    : isPast
                                        ? const Color(0xFF1A73E8)
                                        : Colors.grey.shade400,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${milestone['age']}岁',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isCurrent
                                      ? Colors.white
                                      : isPast
                                          ? const Color(0xFF1A73E8)
                                          : Colors.grey.shade500,
                                ),
                              ),
                              Text(
                                milestone['title'],
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isCurrent
                                      ? Colors.white70
                                      : isPast
                                          ? const Color(0xFF1A73E8).withOpacity(0.7)
                                          : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: 跳转到完整路线图
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('路线图详细页面开发中')),
                        );
                      },
                      child: const Text('查看完整路线图 →'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 底部Slogan ----------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text(
                    '✨ 陪你走到90岁',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '今天的每一步，都为了90岁的自己',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildMetric({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}