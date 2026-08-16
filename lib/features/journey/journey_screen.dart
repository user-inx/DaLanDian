import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/providers/goal_provider.dart';
import '../../life_engine/models/goal.dart';
import '../../life_engine/enums/goal_level.dart';
import '../../life_engine/enums/goal_status.dart';
import '../life/screens/goal_detail_screen.dart';
import 'widgets/journey_timeline.dart';
import 'widgets/journey_current_goal.dart';
import 'widgets/journey_recent_completed.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalProvider.notifier).loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final allGoals = ref.watch(goalProvider);
    final notifier = ref.read(goalProvider.notifier);
    final isLoading = ref.watch(goalProvider.notifier).isLoading;

    // ========================================
    // 数据计算（全部加上显式类型）
    // ========================================

    // 1. 获取 Vision（根目标）
    final List<Goal> visionGoals = notifier.rootGoals;
    final Goal? vision = visionGoals.isNotEmpty ? visionGoals.first : null;

    // 2. 获取 Life 目标（vision 的子目标）
    List<Goal> lifeGoals = <Goal>[];
    Goal? life;
    if (vision != null) {
      lifeGoals = notifier.childrenOf(vision.id);
      if (lifeGoals.isNotEmpty) {
        life = lifeGoals.firstWhere(
          (Goal g) => g.level == GoalLevel.life,
          orElse: () => lifeGoals.first,
        );
      }
    }

    // 3. 获取 Milestone 目标（life 的子目标）
    List<Goal> milestones = <Goal>[];
    if (life != null) {
      final List<Goal> milestoneGoals = notifier.childrenOf(life.id);
      milestones = milestoneGoals.where((Goal g) => g.level == GoalLevel.milestone).toList();
    }

    // 4. 当前目标
    final Goal? currentGoal = notifier.getCurrentGoal();

    // 5. 最近完成
    final List<Goal> recentCompleted = notifier.getRecentCompleted(limit: 3);

    // 6. 统计信息
    final int totalGoals = allGoals.length;
    final int completedCount = allGoals.where((Goal g) => g.status == GoalStatus.completed).length;
    final int doingCount = allGoals.where((Goal g) => g.status == GoalStatus.doing).length;
    final double overallProgress = totalGoals > 0 ? completedCount / totalGoals : 0.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '我的成长路径',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ========================================
                  // 1. 顶部信息卡片
                  // ========================================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vision?.title ?? '设定你的人生愿景',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (vision != null && vision.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            vision.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildStatItem(
                              '总目标',
                              '$totalGoals',
                              Colors.white.withOpacity(0.9),
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              '已完成',
                              '$completedCount',
                              Colors.green.shade200,
                            ),
                            const SizedBox(width: 24),
                            _buildStatItem(
                              '进行中',
                              '$doingCount',
                              Colors.orange.shade200,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(overallProgress * 100).toInt()}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: overallProgress,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            color: Colors.white,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========================================
                  // 2. 成长路径 Timeline
                  // ========================================
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
                        const Text(
                          '✨ 成长路径',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          life?.title ?? '设定你的人生目标，开启成长之路',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        JourneyTimeline(
                          milestones: milestones,
                          onGoalTap: (String goalId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoalDetailScreen(goalId: goalId),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========================================
                  // 3. 当前目标
                  // ========================================
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
                        const Text(
                          '🎯 当前目标',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        JourneyCurrentGoal(
                          goal: currentGoal,
                          onTap: (String goalId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoalDetailScreen(goalId: goalId),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========================================
                  // 4. 最近完成
                  // ========================================
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
                        const Text(
                          '✅ 最近完成',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        JourneyRecentCompleted(
                          completedGoals: recentCompleted,
                          onTap: (String goalId) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoalDetailScreen(goalId: goalId),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ========================================
                  // 5. 底部激励
                  // ========================================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          color: Color(0xFF1A73E8),
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '每一步都算数，你正在成为 90 岁时想成为的人',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1A73E8).withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}