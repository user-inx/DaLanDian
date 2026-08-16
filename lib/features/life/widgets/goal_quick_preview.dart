import 'package:flutter/material.dart';
import '../../../life_engine/models/goal.dart';
import '../../../life_engine/enums/goal_category.dart';
import '../../../life_engine/enums/goal_level.dart';
import '../../../life_engine/enums/goal_status.dart';
import '../screens/goal_detail_screen.dart';

class GoalQuickPreview extends StatelessWidget {
  final Goal goal;
  const GoalQuickPreview({super.key, required this.goal});

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailScreen(goalId: goal.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  _getCategoryIcon(goal.category),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Text(
                        _getCategoryLabel(goal.category),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _getStatusColor(goal.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _getStatusLabel(goal.status),
                          style: TextStyle(
                            fontSize: 10,
                            color: _getStatusColor(goal.status),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getLevelLabel(goal.level),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  '${(goal.progress * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
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
      ),
    );
  }
}