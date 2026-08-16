import 'package:flutter/material.dart';
import '../../../life_engine/models/goal.dart';
import '../../../life_engine/enums/goal_status.dart';
import 'journey_milestone_card.dart';

class JourneyTimeline extends StatelessWidget {
  final List<Goal> milestones;
  final Function(String) onGoalTap;

  const JourneyTimeline({
    super.key,
    required this.milestones,
    required this.onGoalTap,
  });

  @override
  Widget build(BuildContext context) {
    if (milestones.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Text(
            '还没有里程碑，开始设定你的人生目标吧 🎯',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < milestones.length; i++) {
      final Goal milestone = milestones[i];
      final bool isLast = i == milestones.length - 1;

      children.add(
        JourneyMilestoneCard(
          goal: milestone,
          onTap: onGoalTap,
        ),
      );

      if (!isLast) {
        children.add(_buildConnector(milestone));
      }
    }

    return Column(children: children);
  }

  Widget _buildConnector(Goal milestone) {
    final bool isCompleted = milestone.status == GoalStatus.completed;
    final bool isDoing = milestone.status == GoalStatus.doing;

    Color color;
    if (isCompleted) {
      color = Colors.green;
    } else if (isDoing) {
      color = const Color(0xFF1A73E8);
    } else {
      color = Colors.grey.shade300;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 32,
        width: 2,
        color: color,
      ),
    );
  }
}