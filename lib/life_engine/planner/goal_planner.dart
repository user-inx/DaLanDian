import 'package:app/life_engine/models/goal.dart';

class GoalPlanner {

  Goal? getTodayPrimaryGoal(
    List<Goal> goals,
  ) {

    if (goals.isEmpty) {
      return null;
    }

    goals.sort(
      (a, b) => b.priority.compareTo(a.priority),
    );

    return goals.first;

  }

}