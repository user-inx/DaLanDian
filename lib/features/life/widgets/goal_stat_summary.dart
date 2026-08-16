import 'package:flutter/material.dart';
import '../../../life_engine/models/goal.dart';
import '../../../life_engine/enums/goal_status.dart';

class GoalStatSummary extends StatelessWidget {
  final List<Goal> goals;
  const GoalStatSummary({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    final total = goals.length;
    final inProgress = goals.where((g) => g.status == GoalStatus.doing).length;
    final completed = goals.where((g) => g.status == GoalStatus.completed).length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat('总目标', total.toString(), Colors.blue),
        _buildStat('进行中', inProgress.toString(), Colors.orange),
        _buildStat('已完成', completed.toString(), Colors.green),
      ],
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}