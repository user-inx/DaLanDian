import '../../core/base/entity.dart';

import '../enums/goal_category.dart';
import '../enums/goal_level.dart';
import '../enums/goal_status.dart';

class Goal extends Entity {
  final String? parentId;

  final String title;

  final String description;

  final GoalLevel level;

  final GoalCategory category;

  final GoalStatus status;

  final int priority;

  final int estimatedMinutes;

  final double progress;

  final DateTime? deadline;

  final DateTime? completedAt;

  const Goal({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.parentId,
    required this.title,
    required this.description,
    required this.level,
    required this.category,
    required this.status,
    required this.priority,
    required this.estimatedMinutes,
    required this.progress,
    this.deadline,
    this.completedAt,
  });

  Goal copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentId,
    String? title,
    String? description,
    GoalLevel? level,
    GoalCategory? category,
    GoalStatus? status,
    int? priority,
    int? estimatedMinutes,
    double? progress,
    DateTime? deadline,
    DateTime? completedAt,
  }) {
    return Goal(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentId: parentId ?? this.parentId,
      title: title ?? this.title,
      description: description ?? this.description,
      level: level ?? this.level,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      estimatedMinutes:
          estimatedMinutes ?? this.estimatedMinutes,
      progress: progress ?? this.progress,
      deadline: deadline ?? this.deadline,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}