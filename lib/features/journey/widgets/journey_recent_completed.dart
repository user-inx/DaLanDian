import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../life_engine/models/goal.dart';

class JourneyRecentCompleted extends StatelessWidget {
  final List<Goal> completedGoals;
  final Function(String) onTap;

  const JourneyRecentCompleted({
    super.key,
    required this.completedGoals,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (completedGoals.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            '还没有完成的目标，继续加油！💪',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ),
      );
    }

    final List<Widget> children = <Widget>[];
    for (final Goal goal in completedGoals) {
      children.add(
        GestureDetector(
          onTap: () => onTap(goal.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        goal.title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (goal.completedAt != null)
                        Text(
                          DateFormat('yyyy年MM月dd日').format(goal.completedAt!),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(children: children);
  }
}