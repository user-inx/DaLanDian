import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../life_engine/providers/goal_provider.dart';
import '../../../life_engine/models/goal.dart';
import '../../../life_engine/enums/goal_category.dart';  // ← 新增
import '../../../life_engine/enums/goal_level.dart';      // ← 新增
import '../../../life_engine/enums/goal_status.dart';
import '../models/ai_plan.dart';
import 'ai_goal_analysis_screen.dart';

class AiJourneyStartScreen extends ConsumerStatefulWidget {
  const AiJourneyStartScreen({super.key});

  @override
  ConsumerState<AiJourneyStartScreen> createState() => _AiJourneyStartScreenState();
}

class _AiJourneyStartScreenState extends ConsumerState<AiJourneyStartScreen> {
  bool _useCustomGoal = false;
  final TextEditingController _customGoalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalProvider.notifier).loadGoals();
    });
  }

  @override
  void dispose() {
    _customGoalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalProvider);
    final isLoading = ref.watch(goalProvider.notifier).isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '开始 AI 陪跑',
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '选择一个已有目标进行 AI 分析，或创建一个临时目标开始你的 AI 陪跑之旅。',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                const Text(
                  '使用自定义目标',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Switch(
                  value: _useCustomGoal,
                  onChanged: (value) {
                    setState(() {
                      _useCustomGoal = value;
                    });
                  },
                  activeColor: const Color(0xFF1A73E8),
                ),
              ],
            ),

            if (_useCustomGoal) ...[
              const SizedBox(height: 8),
              TextField(
                controller: _customGoalController,
                decoration: InputDecoration(
                  hintText: '输入你的自定义目标，如：3个月减重10斤',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF1A73E8)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                maxLines: 2,
              ),
            ],

            const SizedBox(height: 16),

            if (!_useCustomGoal) ...[
              const Text(
                '选择你的目标',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              if (isLoading)
                const Center(child: CircularProgressIndicator())
              else if (goals.isEmpty)
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '还没有目标',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '请先在"人生"页面创建目标',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...goals.map((goal) => _buildGoalTile(goal, context)),
            ],

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                if (_useCustomGoal) {
                  final customTitle = _customGoalController.text.trim();
                  if (customTitle.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('请输入自定义目标'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }
                  final tempGoal = Goal(
                    id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
                    parentId: null,
                    title: customTitle,
                    description: '自定义目标（AI 陪跑专用）',
                    level: GoalLevel.goal,
                    category: GoalCategory.health,
                    status: GoalStatus.doing,
                    priority: 2,
                    estimatedMinutes: 0,
                    progress: 0.0,
                    deadline: DateTime.now().add(const Duration(days: 90)),
                    completedAt: null,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  );
                  _startAiJourney(tempGoal);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '继续',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalTile(Goal goal, BuildContext context) {
    final statusColor = goal.status == GoalStatus.completed ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF1A73E8).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              _getCategoryIcon(goal.category),
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        title: Text(
          goal.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getCategoryLabel(goal.category),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusLabel(goal.status),
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(goal.progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: goal.progress,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                      minHeight: 3,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () => _startAiJourney(goal),
      ),
    );
  }

  void _startAiJourney(Goal goal) {
    final plan = AiPlan.fromGoal(goal);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AiGoalAnalysisScreen(plan: plan),
      ),
    );
  }

  String _getCategoryIcon(GoalCategory category) {
    switch (category) {
      case GoalCategory.health:
        return '💪';
      case GoalCategory.career:
        return '💼';
      case GoalCategory.wealth:
        return '💰';
      case GoalCategory.family:
        return '👨‍👩‍👧‍👦';
      case GoalCategory.learning:
        return '📚';
      case GoalCategory.social:
        return '🤝';
      case GoalCategory.hobby:
        return '🎨';
      case GoalCategory.spiritual:
        return '🧘';
    }
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
}