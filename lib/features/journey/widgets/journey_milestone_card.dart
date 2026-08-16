import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../life_engine/models/goal.dart';
import '../../../life_engine/enums/goal_status.dart';

class JourneyMilestoneCard extends StatelessWidget {
  final Goal goal;
  final Function(String) onTap;

  const JourneyMilestoneCard({
    super.key,
    required this.goal,
    required this.onTap,
  });

  String _getStatusLabel(GoalStatus status) {
    switch (status) {
      case GoalStatus.waiting:
        return '未开始';
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
        return const Color(0xFF1A73E8);
      case GoalStatus.completed:
        return Colors.green;
      case GoalStatus.failed:
        return Colors.red;
    }
  }

  IconData _getStatusIcon(GoalStatus status) {
    switch (status) {
      case GoalStatus.waiting:
        return Icons.radio_button_unchecked;
      case GoalStatus.doing:
        return Icons.radio_button_checked;
      case GoalStatus.completed:
        return Icons.check_circle;
      case GoalStatus.failed:
        return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(goal.status);
    final bool isCompleted = goal.status == GoalStatus.completed;
    final bool isDoing = goal.status == GoalStatus.doing;

    Color bgColor;
    Color borderColor;
    Color textColor;

    if (isCompleted) {
      bgColor = const Color(0xFFE8F5E9);
      borderColor = Colors.green;
      textColor = Colors.black87;
    } else if (isDoing) {
      bgColor = const Color(0xFFE8F0FE);
      borderColor = const Color(0xFF1A73E8);
      textColor = Colors.black87;
    } else {
      bgColor = Colors.grey.shade50;
      borderColor = Colors.grey.shade300;
      textColor = Colors.grey.shade600;
    }

    return GestureDetector(
      onTap: () => onTap(goal.id),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: isDoing ? 2 : 1,
          ),
          boxShadow: isDoing
              ? <BoxShadow>[
                  BoxShadow(
                    color: const Color(0xFF1A73E8).withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getStatusIcon(goal.status),
                color: statusColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          goal.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: isDoing ? FontWeight.w600 : FontWeight.w500,
                            color: textColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isDoing)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A73E8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            '当前',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (goal.description.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      goal.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor.withOpacity(0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _getStatusLabel(goal.status),
                          style: TextStyle(
                            fontSize: 11,
                            color: statusColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(goal.progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: goal.progress,
                            backgroundColor: Colors.grey.shade200,
                            color: statusColor,
                            minHeight: 3,
                          ),
                        ),
                      ),
                      if (goal.deadline != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('yyyy/MM/dd').format(goal.deadline!),
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: textColor.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}