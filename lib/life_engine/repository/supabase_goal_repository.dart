import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/goal.dart';
import '../mapper/goal_mapper.dart';
import 'goal_repository.dart';
import '../../core/services/supabase_service.dart';

class SupabaseGoalRepository extends GoalRepository {
  // 注意：不继承 MockRepository，而是直接实现所有方法
  
  static const String _tableName = 'goals';

  SupabaseClient get _client => SupabaseService().client;

  /// 获取所有目标
  @override
  Future<List<Goal>> getGoals() async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((item) => GoalMapper.fromMap(item as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('加载目标失败: ${e.message}');
    } catch (e) {
      throw Exception('加载目标失败: $e');
    }
  }

  /// 根据 ID 获取单个目标
  @override
  Future<Goal?> getGoalById(String id) async {
    try {
      final goals = await getGoals();
      return goals.firstWhere((goal) => goal.id == id);
    } catch (_) {
      return null;
    }
  }

  /// 获取根目标（parentId == null）
  @override
  Future<List<Goal>> getRootGoals() async {
    final goals = await getGoals();
    return goals.where((goal) => goal.parentId == null).toList();
  }

  /// 获取指定父目标的所有子目标
  @override
  Future<List<Goal>> getChildren(String parentId) async {
    final goals = await getGoals();
    return goals.where((goal) => goal.parentId == parentId).toList();
  }

  /// 获取已完成的目标（progress >= 1）
  @override
  Future<List<Goal>> getCompletedGoals() async {
    final goals = await getGoals();
    return goals.where((goal) => goal.progress >= 1.0).toList();
  }

  /// 获取进行中的目标（progress < 1）
  @override
  Future<List<Goal>> getRunningGoals() async {
    final goals = await getGoals();
    return goals.where((goal) => goal.progress < 1.0).toList();
  }

  /// 计算所有目标的平均进度
  @override
  Future<double> getOverallProgress() async {
    final goals = await getGoals();
    if (goals.isEmpty) return 0.0;
    double total = 0.0;
    for (final goal in goals) {
      total += goal.progress;
    }
    return total / goals.length;
  }

  /// 保存新目标（插入）
  @override
  Future<void> saveGoal(Goal goal) async {
    try {
      final map = GoalMapper.toMap(goal);
      // 移除数据库自动生成的字段
      map.remove('id');
      map.remove('created_at');
      map.remove('updated_at');

      await _client.from(_tableName).insert(map);
    } on PostgrestException catch (e) {
      throw Exception('保存目标失败: ${e.message}');
    } catch (e) {
      throw Exception('保存目标失败: $e');
    }
  }

  /// 更新目标
  @override
  Future<void> updateGoal(Goal goal) async {
    try {
      final map = GoalMapper.toMap(goal);
      // 移除不允许更新的字段
      map.remove('id');
      map.remove('created_at');
      // updated_at 由数据库触发器自动更新

      await _client
          .from(_tableName)
          .update(map)
          .eq('id', goal.id);
    } on PostgrestException catch (e) {
      throw Exception('更新目标失败: ${e.message}');
    } catch (e) {
      throw Exception('更新目标失败: $e');
    }
  }

  /// 删除目标
  @override
  Future<void> deleteGoal(String id) async {
    try {
      await _client
          .from(_tableName)
          .delete()
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('删除目标失败: ${e.message}');
    } catch (e) {
      throw Exception('删除目标失败: $e');
    }
  }
}