import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../life_engine/providers/goal_provider.dart';
import '../../../life_engine/enums/goal_category.dart';
import '../../../life_engine/enums/goal_level.dart';
import '../../../life_engine/enums/goal_status.dart';
import 'goal_create_screen.dart';
import 'goal_breakdown_screen.dart';

class GoalDetailScreen extends ConsumerStatefulWidget {
  final String goalId;
  const GoalDetailScreen({super.key, required this.goalId});

  @override
  ConsumerState<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends ConsumerState<GoalDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final found = ref.read(goalProvider.notifier).findById(widget.goalId);
      if (found == null) {
        ref.read(goalProvider.notifier).loadGoals();
      }
    });
  }

  String _getCategoryLabel(GoalCategory category) {
    switch (category) {
      case GoalCategory.health:
        return '健康';
      case GoalCategory.career:
        return '事业';
      case GoalCategory.wealth:
        return '财富';
      case GoalCategory.family:
        return '家庭';
      case GoalCategory.learning:
        return '学习';
      case GoalCategory.social:
        return '社交';
      case GoalCategory.hobby:
        return '兴趣';
      case GoalCategory.spiritual:
        return '灵性';
    }
  }

  String _getLevelLabel(GoalLevel level) {
    switch (level) {
      case GoalLevel.vision:
        return '愿景';
      case GoalLevel.life:
        return '人生';
      case GoalLevel.milestone:
        return '里程碑';
      case GoalLevel.goal:
        return '目标';
      case GoalLevel.task:
        return '任务';
    }
  }

  String _getStatusLabel(GoalStatus status) {
    switch (status) {
      case GoalStatus.waiting:
        return '等待中';
      case GoalStatus.doing:
        return '进行中';
      case GoalStatus.completed:
        return '已完成';
      case GoalStatus.failed:
        return '已失败';
    }
  }

  Color _getStatusColor(GoalStatus status) {
    switch (status) {
      case GoalStatus.waiting:
        return Colors.grey;
      case GoalStatus.doing:
        return Colors.orange;
      case GoalStatus.completed:
        return Colors.green;
      case GoalStatus.failed:
        return Colors.red;
    }
  }

  String _getPriorityLabel(int priority) {
    switch (priority) {
      case 1:
        return '低';
      case 2:
        return '中';
      case 3:
        return '高';
      default:
        return '中';
    }
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  int _calculateRemainingDays(DateTime deadline) {
    final now = DateTime.now();
    return deadline.difference(now).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final goal = ref.watch(goalProvider.notifier).findById(widget.goalId);

    if (goal == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: const Text(
            '目标详情',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final remainingDays = goal.deadline != null
        ? _calculateRemainingDays(goal.deadline!)
        : null;

    final isOverdue = remainingDays != null && remainingDays < 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '目标详情',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- 目标名称 ----------
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(goal.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getStatusLabel(goal.status),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(goal.status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _getLevelLabel(goal.level),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (goal.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      goal.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 信息卡片 ----------
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
                children: [
                  _buildInfoRow(
                    icon: Icons.category_outlined,
                    label: '分类',
                    value: _getCategoryLabel(goal.category),
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    icon: Icons.flag_outlined,
                    label: '优先级',
                    value: _getPriorityLabel(goal.priority),
                    valueColor: _getPriorityColor(goal.priority),
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: '开始日期',
                    value: DateFormat('yyyy年MM月dd日').format(goal.createdAt),
                  ),
                  const Divider(height: 16),
                  _buildInfoRow(
                    icon: Icons.event_outlined,
                    label: '截止日期',
                    value: goal.deadline != null
                        ? DateFormat('yyyy年MM月dd日').format(goal.deadline!)
                        : '未设置',
                    valueColor: isOverdue ? Colors.red : null,
                  ),
                  if (goal.deadline != null) ...[
                    const Divider(height: 16),
                    _buildInfoRow(
                      icon: Icons.timer_outlined,
                      label: '剩余天数',
                      // ✅ 修复：移除多余的 !
                      value: isOverdue
                          ? '已过期 ${remainingDays.abs()} 天'
                          : '$remainingDays 天',
                      valueColor: isOverdue ? Colors.red : Colors.blue,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 进度卡片 ----------
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '完成进度',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        '${(goal.progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '进度 ${(goal.progress * 100).toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 操作按钮 ----------
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalCreateScreen(
                            editingGoal: goal,
                          ),
                        ),
                      ).then((_) {
                        ref.read(goalProvider.notifier).loadGoals();
                        setState(() {});
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A73E8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      '编辑目标',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GoalBreakdownScreen(goalId: goal.id),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1A73E8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: const BorderSide(color: Color(0xFF1A73E8)),
                    ),
                    child: const Text(
                      '目标拆解',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Center(
              child: Text(
                '创建于 ${DateFormat('yyyy年MM月dd日').format(goal.createdAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}