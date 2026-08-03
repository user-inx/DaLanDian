import '../enums/goal_category.dart';
import '../enums/goal_level.dart';
import '../enums/goal_status.dart';
import '../models/goal.dart';

final mockGoals = [

  Goal(
    id: "goal_001",
    parentId: null,
    title: "打造大蓝典",
    description: "打造全球最大的男性成长平台",
    level: GoalLevel.life,
    category: GoalCategory.career,
    status: GoalStatus.doing,
    priority: 5,
    estimatedMinutes: 0,
    progress: 0.08,
    createdAt: DateTime(2026, 8, 1),
    updatedAt: DateTime(2026, 8, 2),
  ),

  Goal(
    id: "goal_002",
    parentId: "goal_001",
    title: "完成 Today 页面",
    description: "完成首页开发",
    level: GoalLevel.goal,
    category: GoalCategory.career,
    status: GoalStatus.doing,
    priority: 5,
    estimatedMinutes: 180,
    progress: 0.65,
    createdAt: DateTime(2026, 8, 2),
    updatedAt: DateTime(2026, 8, 2),
  ),
];