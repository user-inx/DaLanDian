import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/goal.dart';
import '../enums/goal_level.dart';
import '../enums/goal_category.dart';
import '../enums/goal_status.dart';
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
  GoalNotifier(this._repository) : super(const []);

  final GoalRepository _repository;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> loadGoals() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    try {
      // 🔥 硬编码模拟数据（使用正确的枚举值）
      final now = DateTime.now();
      final List<Goal> mockGoals = [
        Goal(
          id: '1',
          createdAt: now,
          updatedAt: now,
          parentId: null,
          title: '保持每日运动习惯',
          description: '每天坚持运动 30 分钟',
          level: GoalLevel.life,
          category: GoalCategory.health,
          status: GoalStatus.doing,
          priority: 1,
          estimatedMinutes: 30,
          progress: 0.6,
          deadline: null,
          completedAt: null,
        ),
        Goal(
          id: '2',
          createdAt: now,
          updatedAt: now,
          parentId: 'root-health',
          title: '晨跑 5 公里',
          description: '早晨跑步 5 公里',
          level: GoalLevel.task,
          category: GoalCategory.health,
          status: GoalStatus.doing,
          priority: 2,
          estimatedMinutes: 45,
          progress: 0.8,
          deadline: null,
          completedAt: null,
        ),
        Goal(
          id: '3',
          createdAt: now,
          updatedAt: now,
          parentId: 'root-health',
          title: '晚间瑜伽拉伸',
          description: '晚上做瑜伽拉伸',
          level: GoalLevel.task,
          category: GoalCategory.health,
          status: GoalStatus.doing,
          priority: 3,
          estimatedMinutes: 20,
          progress: 0.0,
          deadline: null,
          completedAt: null,
        ),
        Goal(
          id: '4',
          createdAt: now,
          updatedAt: now,
          parentId: 'root-health',
          title: '正念冥想 10 分钟',
          description: '每天冥想 10 分钟',
          level: GoalLevel.task,
          category: GoalCategory.spiritual,
          status: GoalStatus.completed,
          priority: 1,
          estimatedMinutes: 10,
          progress: 1.0,
          deadline: null,
          completedAt: now,
        ),
      ];

      state = List<Goal>.unmodifiable(mockGoals);
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    await loadGoals();
  }

  Future<void> addGoal(Goal goal) async {
    await _repository.saveGoal(goal);
    state = List<Goal>.unmodifiable([
      goal,
      ...state,
    ]);
  }

  Future<void> updateGoal(Goal goal) async {
    await _repository.updateGoal(goal);
    state = List<Goal>.unmodifiable([
      for (final Goal item in state)
        if (item.id == goal.id) goal else item,
    ]);
  }

  Future<void> removeGoal(String id) async {
    await _repository.deleteGoal(id);
    state = List<Goal>.unmodifiable(
      state.where((Goal goal) => goal.id != id),
    );
  }

  Goal? findById(String id) {
    for (final Goal goal in state) {
      if (goal.id == id) {
        return goal;
      }
    }
    return null;
  }

  List<Goal> get rootGoals {
    return state
        .where((Goal goal) => goal.parentId == null)
        .toList();
  }

  List<Goal> childrenOf(String parentId) {
    return state
        .where((Goal goal) => goal.parentId == parentId)
        .toList();
  }

  double get totalProgress {
    if (state.isEmpty) {
      return 0.0;
    }
    double total = 0.0;
    for (final Goal goal in state) {
      total += goal.progress;
    }
    return total / state.length;
  }
}