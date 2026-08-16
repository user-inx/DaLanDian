import '../models/goal.dart';
import '../enums/goal_level.dart';
import '../enums/goal_category.dart';
import '../enums/goal_status.dart';

/// Goal ↔ Supabase Map 转换工具
class GoalMapper {
  /// 将 Supabase Map 转换为 Goal 对象
  static Goal fromMap(Map<String, dynamic> map) {
    return Goal(
      id: map['id'] as String,
      parentId: map['parent_id'] as String?,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      level: _stringToGoalLevel(map['level'] as String),
      category: _stringToGoalCategory(map['category'] as String),
      status: _stringToGoalStatus(map['status'] as String),
      priority: map['priority'] as int? ?? 3,
      estimatedMinutes: map['estimated_minutes'] as int? ?? 0,
      progress: (map['progress'] as num?)?.toDouble() ?? 0.0,
      deadline: map['deadline'] != null
          ? DateTime.parse(map['deadline'] as String)
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.parse(map['completed_at'] as String)
          : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// 将 Goal 对象转换为 Supabase Map
  static Map<String, dynamic> toMap(Goal goal) {
    return {
      'id': goal.id,
      'parent_id': goal.parentId,
      'title': goal.title,
      'description': goal.description,
      'level': _goalLevelToString(goal.level),
      'category': _goalCategoryToString(goal.category),
      'status': _goalStatusToString(goal.status),
      'priority': goal.priority,
      'estimated_minutes': goal.estimatedMinutes,
      'progress': goal.progress,
      'deadline': goal.deadline?.toIso8601String(),
      'completed_at': goal.completedAt?.toIso8601String(),
      'created_at': goal.createdAt.toIso8601String(),
      'updated_at': goal.updatedAt.toIso8601String(),
    };
  }

  static String _goalLevelToString(GoalLevel level) {
    switch (level) {
      case GoalLevel.vision:
        return 'vision';
      case GoalLevel.life:
        return 'life';
      case GoalLevel.milestone:
        return 'milestone';
      case GoalLevel.goal:
        return 'goal';
      case GoalLevel.task:
        return 'task';
    }
  }

  static GoalLevel _stringToGoalLevel(String value) {
    switch (value) {
      case 'vision':
        return GoalLevel.vision;
      case 'life':
        return GoalLevel.life;
      case 'milestone':
        return GoalLevel.milestone;
      case 'goal':
        return GoalLevel.goal;
      case 'task':
        return GoalLevel.task;
      default:
        throw ArgumentError('Unknown GoalLevel: $value');
    }
  }

  static String _goalCategoryToString(GoalCategory category) {
    switch (category) {
      case GoalCategory.health:
        return 'health';
      case GoalCategory.career:
        return 'career';
      case GoalCategory.wealth:
        return 'wealth';
      case GoalCategory.family:
        return 'family';
      case GoalCategory.learning:
        return 'learning';
      case GoalCategory.social:
        return 'social';
      case GoalCategory.hobby:
        return 'hobby';
      case GoalCategory.spiritual:
        return 'spiritual';
    }
  }

  static GoalCategory _stringToGoalCategory(String value) {
    switch (value) {
      case 'health':
        return GoalCategory.health;
      case 'career':
        return GoalCategory.career;
      case 'wealth':
        return GoalCategory.wealth;
      case 'family':
        return GoalCategory.family;
      case 'learning':
        return GoalCategory.learning;
      case 'social':
        return GoalCategory.social;
      case 'hobby':
        return GoalCategory.hobby;
      case 'spiritual':
        return GoalCategory.spiritual;
      default:
        throw ArgumentError('Unknown GoalCategory: $value');
    }
  }

  static String _goalStatusToString(GoalStatus status) {
    switch (status) {
      case GoalStatus.waiting:
        return 'waiting';
      case GoalStatus.doing:
        return 'doing';
      case GoalStatus.completed:
        return 'completed';
      case GoalStatus.failed:
        return 'failed';
    }
  }

  static GoalStatus _stringToGoalStatus(String value) {
    switch (value) {
      case 'waiting':
        return GoalStatus.waiting;
      case 'doing':
        return GoalStatus.doing;
      case 'completed':
        return GoalStatus.completed;
      case 'failed':
        return GoalStatus.failed;
      default:
        throw ArgumentError('Unknown GoalStatus: $value');
    }
  }
}