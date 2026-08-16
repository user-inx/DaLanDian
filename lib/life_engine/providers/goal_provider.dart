import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/goal.dart';
import '../enums/goal_level.dart';
import '../enums/goal_category.dart';
import '../enums/goal_status.dart';
import '../repository/goal_repository.dart';
// 🔥 新增：导入 Supabase 实现
import '../repository/supabase_goal_repository.dart';
import 'package:uuid/uuid.dart';

// 🔥 修改：将 Repository 改为 Supabase 版本
final goalRepositoryProvider = Provider<GoalRepository>(
  (ref) => SupabaseGoalRepository(),  // ← 原来为 GoalRepository()
);

final goalProvider = StateNotifierProvider<GoalNotifier, List<Goal>>(
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

  final Uuid _uuid = const Uuid();

  // 🔥 保留 Mock 数据方法，但不再使用（后续 Task 清理）
  // 目前保留是为了不破坏代码结构
  List<Goal> _buildMockGoals() {
    final now = DateTime.now();

    final visionId = _uuid.v4();
    final vision = Goal(
      id: visionId,
      createdAt: now,
      updatedAt: now,
      parentId: null,
      title: '成为更健康、更自律、更有能力的人',
      description: '用持续的行动，塑造一个更好的自己',
      level: GoalLevel.vision,
      category: GoalCategory.health,
      status: GoalStatus.doing,
      priority: 1,
      estimatedMinutes: 0,
      progress: 0.35,
      deadline: null,
      completedAt: null,
    );

    final lifeId = _uuid.v4();
    final life = Goal(
      id: lifeId,
      createdAt: now,
      updatedAt: now,
      parentId: visionId,
      title: '建立长期健康生活方式',
      description: '让健康成为生活的一部分，而不是任务',
      level: GoalLevel.life,
      category: GoalCategory.health,
      status: GoalStatus.doing,
      priority: 1,
      estimatedMinutes: 0,
      progress: 0.5,
      deadline: DateTime(2027, 12, 31),
      completedAt: null,
    );

    final milestoneId1 = _uuid.v4();
    final milestone1 = Goal(
      id: milestoneId1,
      createdAt: now,
      updatedAt: now,
      parentId: lifeId,
      title: '完成第一阶段体能提升',
      description: '建立运动习惯，提升基础体能',
      level: GoalLevel.milestone,
      category: GoalCategory.health,
      status: GoalStatus.completed,
      priority: 1,
      estimatedMinutes: 0,
      progress: 1.0,
      deadline: DateTime(2026, 6, 30),
      completedAt: DateTime(2026, 6, 28),
    );

    final milestoneId2 = _uuid.v4();
    final milestone2 = Goal(
      id: milestoneId2,
      createdAt: now,
      updatedAt: now,
      parentId: lifeId,
      title: '达成目标体重与体态',
      description: '通过饮食和运动，达到理想身体状态',
      level: GoalLevel.milestone,
      category: GoalCategory.health,
      status: GoalStatus.doing,
      priority: 1,
      estimatedMinutes: 0,
      progress: 0.6,
      deadline: DateTime(2026, 12, 31),
      completedAt: null,
    );

    final milestoneId3 = _uuid.v4();
    final milestone3 = Goal(
      id: milestoneId3,
      createdAt: now,
      updatedAt: now,
      parentId: lifeId,
      title: '建立长期健康系统',
      description: '让健康习惯自动化，成为生活方式',
      level: GoalLevel.milestone,
      category: GoalCategory.health,
      status: GoalStatus.waiting,
      priority: 2,
      estimatedMinutes: 0,
      progress: 0.0,
      deadline: DateTime(2027, 6, 30),
      completedAt: null,
    );

    final goal1Id = _uuid.v4();
    final goal1 = Goal(
      id: goal1Id,
      createdAt: now,
      updatedAt: now,
      parentId: milestoneId1,
      title: '连续30天保持运动习惯',
      description: '每天至少运动30分钟，坚持30天',
      level: GoalLevel.goal,
      category: GoalCategory.health,
      status: GoalStatus.completed,
      priority: 1,
      estimatedMinutes: 30,
      progress: 1.0,
      deadline: DateTime(2026, 5, 30),
      completedAt: DateTime(2026, 5, 30),
    );

    final goal2Id = _uuid.v4();
    final goal2 = Goal(
      id: goal2Id,
      createdAt: now,
      updatedAt: now,
      parentId: milestoneId2,
      title: '3个月减重10斤',
      description: '通过饮食控制和规律运动，在3个月内减重10斤',
      level: GoalLevel.goal,
      category: GoalCategory.health,
      status: GoalStatus.doing,
      priority: 1,
      estimatedMinutes: 45,
      progress: 0.6,
      deadline: DateTime(2026, 10, 15),
      completedAt: null,
    );

    final goal3Id = _uuid.v4();
    final goal3 = Goal(
      id: goal3Id,
      createdAt: now,
      updatedAt: now,
      parentId: milestoneId3,
      title: '建立健康饮食系统',
      description: '制定并执行科学的饮食计划',
      level: GoalLevel.goal,
      category: GoalCategory.health,
      status: GoalStatus.waiting,
      priority: 2,
      estimatedMinutes: 20,
      progress: 0.0,
      deadline: DateTime(2027, 3, 31),
      completedAt: null,
    );

    final task1 = Goal(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      parentId: goal2Id,
      title: '晨跑5公里',
      description: '每周至少4次晨跑',
      level: GoalLevel.task,
      category: GoalCategory.health,
      status: GoalStatus.doing,
      priority: 1,
      estimatedMinutes: 40,
      progress: 0.7,
      deadline: DateTime(2026, 9, 30),
      completedAt: null,
    );

    final task2 = Goal(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      parentId: goal2Id,
      title: '晚间拉伸20分钟',
      description: '每天睡前拉伸，放松肌肉',
      level: GoalLevel.task,
      category: GoalCategory.health,
      status: GoalStatus.doing,
      priority: 2,
      estimatedMinutes: 20,
      progress: 0.5,
      deadline: null,
      completedAt: null,
    );

    final task3 = Goal(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      parentId: goal2Id,
      title: '记录每日饮食',
      description: '用App记录每餐食物和热量',
      level: GoalLevel.task,
      category: GoalCategory.health,
      status: GoalStatus.completed,
      priority: 3,
      estimatedMinutes: 10,
      progress: 1.0,
      deadline: DateTime(2026, 8, 31),
      completedAt: DateTime(2026, 8, 31),
    );

    final task4 = Goal(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      parentId: goal1Id,
      title: '每日运动30分钟',
      description: '每天坚持运动，形式不限',
      level: GoalLevel.task,
      category: GoalCategory.health,
      status: GoalStatus.completed,
      priority: 1,
      estimatedMinutes: 30,
      progress: 1.0,
      deadline: DateTime(2026, 5, 30),
      completedAt: DateTime(2026, 5, 30),
    );

    final task5 = Goal(
      id: _uuid.v4(),
      createdAt: now,
      updatedAt: now,
      parentId: goal1Id,
      title: '记录运动日志',
      description: '每天记录运动内容和感受',
      level: GoalLevel.task,
      category: GoalCategory.health,
      status: GoalStatus.completed,
      priority: 2,
      estimatedMinutes: 5,
      progress: 1.0,
      deadline: DateTime(2026, 5, 30),
      completedAt: DateTime(2026, 5, 30),
    );

    final existingGoals = [
      Goal(
        id: 'existing_1',
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
    ];

    return [
      vision,
      life,
      milestone1,
      milestone2,
      milestone3,
      goal1,
      goal2,
      goal3,
      task1,
      task2,
      task3,
      task4,
      task5,
      ...existingGoals,
    ];
  }

  // ========================================
  // 🔥 核心修改：loadGoals 从 Supabase 加载
  // ========================================
  Future<void> loadGoals() async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;

    try {
      // 🔥 从 Supabase 读取真实数据
      final goals = await _repository.getGoals();
      state = List<Goal>.unmodifiable(goals);
    } catch (e) {
      // 加载失败时，可以选择保留旧数据或清空
      // 当前方案：清空并抛出异常
      state = const [];
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  Future<void> refresh() async {
    await loadGoals();
  }

  // ========================================
  // 🔥 核心修改：addGoal 写入 Supabase
  // ========================================
  Future<void> addGoal(Goal goal) async {
    await _repository.saveGoal(goal);
    // 重新加载以获取最新数据（包含数据库生成的 id、created_at 等）
    await loadGoals();
  }

  // ========================================
  // 🔥 核心修改：updateGoal 更新 Supabase
  // ========================================
  Future<void> updateGoal(Goal goal) async {
    await _repository.updateGoal(goal);
    // 重新加载以获取最新数据
    await loadGoals();
  }

  // ========================================
  // 🔥 核心修改：removeGoal 从 Supabase 删除
  // ========================================
  Future<void> removeGoal(String id) async {
    await _repository.deleteGoal(id);
    // 重新加载以获取最新数据
    await loadGoals();
  }

  // ========================================
  // 以下方法保持不变
  // ========================================

  Goal? findById(String id) {
    for (final Goal goal in state) {
      if (goal.id == id) {
        return goal;
      }
    }
    return null;
  }

  List<Goal> get rootGoals {
    return state.where((Goal goal) => goal.parentId == null).toList();
  }

  List<Goal> childrenOf(String parentId) {
    return state.where((Goal goal) => goal.parentId == parentId).toList();
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

  List<Goal> getAllDescendants(String parentId) {
    final List<Goal> result = [];
    final directChildren = childrenOf(parentId);
    for (final child in directChildren) {
      result.add(child);
      result.addAll(getAllDescendants(child.id));
    }
    return result;
  }

  List<Goal> getGoalsByLevel(GoalLevel level) {
    return state.where((goal) => goal.level == level).toList();
  }

  Goal? getCurrentGoal() {
    final doingGoals = state
        .where((g) => g.status == GoalStatus.doing && g.level == GoalLevel.goal)
        .toList();
    if (doingGoals.isNotEmpty) {
      return doingGoals.first;
    }
    final doingMilestones = state
        .where((g) => g.status == GoalStatus.doing && g.level == GoalLevel.milestone)
        .toList();
    if (doingMilestones.isNotEmpty) {
      return doingMilestones.first;
    }
    final doingLives = state
        .where((g) => g.status == GoalStatus.doing && g.level == GoalLevel.life)
        .toList();
    if (doingLives.isNotEmpty) {
      return doingLives.first;
    }
    return null;
  }

  List<Goal> getRecentCompleted({int limit = 3}) {
    final completed = state
        .where((g) => g.status == GoalStatus.completed && g.completedAt != null)
        .toList();
    completed.sort((a, b) => b.completedAt!.compareTo(a.completedAt!));
    return completed.take(limit).toList();
  }
}