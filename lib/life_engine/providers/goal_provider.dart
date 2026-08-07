import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/goal.dart';
import '../repository/goal_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => GoalRepository(),
);

final goalProvider =
    StateNotifierProvider<GoalNotifier, List<Goal>>(
  (ref) {
    final repository = ref.watch(goalRepositoryProvider);

    return GoalNotifier(repository);
  },
);

class GoalNotifier extends StateNotifier<List<Goal>> {
  GoalNotifier(this._repository)
      : super([]);

  final GoalRepository _repository;

  Future<void> loadGoals() async {
    state = await _repository.getGoals();
  }

  Future<void> refresh() async {
    await loadGoals();
  }

  Future<void> addGoal(Goal goal) async {
    state = [...state, goal];
  }

  Future<void> updateGoal(Goal goal) async {
    state = [
      for (final item in state)
        if (item.id == goal.id)
          goal
        else
          item,
    ];
  }

  Future<void> removeGoal(String id) async {
    state = state.where((e) => e.id != id).toList();
  }

  Goal? findById(String id) {
    try {
      return state.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Goal> get rootGoals =>
      state.where((e) => e.parentId == null).toList();

  List<Goal> childrenOf(String parentId) =>
      state.where((e) => e.parentId == parentId).toList();

  double get totalProgress {
    if (state.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final goal in state) {
      total += goal.progress;
    }

    return total / state.length;
  }
}