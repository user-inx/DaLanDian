import 'package:app/life_engine/models/goal.dart';

abstract class LifeRepository {
  Future<List<Goal>> loadGoals();

  Future<void> saveGoal(Goal goal);

  Future<void> deleteGoal(String id);
}