import '../mock/mock_repository.dart';
import '../models/goal.dart';

class GoalRepository {
  GoalRepository({
    MockRepository? repository,
  }) : _repository = repository ?? MockRepository();

  final MockRepository _repository;

  Future<List<Goal>> getGoals() async {
    return await _repository.loadGoals();
  }

  Future<Goal?> getGoalById(String id) async {
    final goals = await getGoals();

    try {
      return goals.firstWhere((goal) => goal.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<List<Goal>> getRootGoals() async {
    final goals = await getGoals();

    return goals.where((goal) => goal.parentId == null).toList();
  }

  Future<List<Goal>> getChildren(String parentId) async {
    final goals = await getGoals();

    return goals.where((goal) => goal.parentId == parentId).toList();
  }

  Future<List<Goal>> getCompletedGoals() async {
    final goals = await getGoals();

    return goals.where((goal) => goal.progress >= 1).toList();
  }

  Future<List<Goal>> getRunningGoals() async {
    final goals = await getGoals();

    return goals.where((goal) => goal.progress < 1).toList();
  }

  Future<double> getOverallProgress() async {
    final goals = await getGoals();

    if (goals.isEmpty) return 0;

    double total = 0;

    for (final goal in goals) {
      total += goal.progress;
    }

    return total / goals.length;
  }

  Future<void> saveGoal(Goal goal) async {}

  Future<void> deleteGoal(String id) async {}

  Future<void> updateGoal(Goal goal) async {}
}