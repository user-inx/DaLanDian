import '../models/goal.dart';
import '../enums/goal_level.dart';
import '../enums/goal_status.dart';
import 'package:uuid/uuid.dart';

class GoalSplitter {
  final Uuid _uuid = const Uuid();

  /// 将一个大目标拆解为多个子目标
  ///
  /// [parentGoal] 需要拆解的父目标
  /// [count] 子目标数量（默认 4 个）
  /// [customNames] 可选的自定义子目标名称列表
  ///
  /// 返回子目标列表（已设置 parentId）
  List<Goal> split({
    required Goal parentGoal,
    int count = 4,
    List<String>? customNames,
  }) {
    // 限制数量范围
    final actualCount = count.clamp(2, 10);

    // 生成子目标名称
    final List<String> names;
    if (customNames != null && customNames.length >= actualCount) {
      names = customNames.take(actualCount).toList();
    } else {
      names = _generateDefaultNames(parentGoal.title, actualCount);
    }

    // 计算每个子目标的建议截止日期
    final List<DateTime?> subDeadlines = _distributeDeadline(
      parentGoal.deadline,
      actualCount,
    );

    // 创建子目标列表
    final List<Goal> children = [];

    for (int i = 0; i < actualCount; i++) {
      final child = Goal(
        id: _uuid.v4(),
        parentId: parentGoal.id,
        title: names[i],
        description: '子目标 ${i + 1}：${names[i]}',
        level: GoalLevel.task,
        category: parentGoal.category,
        status: GoalStatus.waiting,
        priority: parentGoal.priority,
        estimatedMinutes: 0,
        progress: 0.0,
        deadline: subDeadlines[i],
        completedAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      children.add(child);
    }

    return children;
  }

  /// 生成默认的子目标名称
  List<String> _generateDefaultNames(String parentTitle, int count) {
    final List<String> templates = [
      '制定详细计划',
      '收集必要资源',
      '执行第一阶段',
      '执行第二阶段',
      '执行第三阶段',
      '总结与复盘',
      '优化调整',
      '最终验收',
    ];

    // 根据父标题关键词生成更有针对性的子目标
    if (parentTitle.contains('健康') || parentTitle.contains('健身') || parentTitle.contains('减')) {
      final List<String> healthNames = [
        '制定健康计划',
        '建立日常习惯',
        '坚持运动锻炼',
        '饮食管理调整',
        '定期测量记录',
        '复盘优化方案',
      ];
      return healthNames.take(count).toList();
    }

    if (parentTitle.contains('学习') || parentTitle.contains('阅读') || parentTitle.contains('技能')) {
      final List<String> learnNames = [
        '制定学习计划',
        '收集学习资料',
        '每日学习实践',
        '完成阶段性目标',
        '总结学习笔记',
        '成果检验反馈',
      ];
      return learnNames.take(count).toList();
    }

    if (parentTitle.contains('事业') || parentTitle.contains('工作') || parentTitle.contains('副业')) {
      final List<String> careerNames = [
        '制定工作计划',
        '完成核心任务',
        '拓展关键技能',
        '建立工作系统',
        '达成业绩目标',
        '复盘迭代优化',
      ];
      return careerNames.take(count).toList();
    }

    // 通用模板
    final result = <String>[];
    for (int i = 0; i < count && i < templates.length; i++) {
      result.add(templates[i]);
    }
    // 如果 count > templates.length，补充通用名称
    while (result.length < count) {
      result.add('子目标 ${result.length + 1}');
    }
    return result;
  }

  /// 将截止日期均匀分配到各个子目标
  List<DateTime?> _distributeDeadline(DateTime? parentDeadline, int count) {
    if (parentDeadline == null) {
      return List<DateTime?>.filled(count, null);
    }

    final now = DateTime.now();
    final totalDays = parentDeadline.difference(now).inDays;

    if (totalDays < count) {
      // 时间太紧，分配到每天
      final List<DateTime?> result = [];
      for (int i = 1; i <= count; i++) {
        result.add(now.add(Duration(days: i)));
      }
      return result;
    }

    // 均匀分配天数
    final step = totalDays ~/ count;
    final List<DateTime?> result = [];
    for (int i = 1; i <= count; i++) {
      result.add(now.add(Duration(days: step * i)));
    }
    return result;
  }

  /// 判断一个目标是否可以被拆解
  bool canSplit(Goal goal) {
    // 如果是任务级别，不再拆解
    if (goal.level == GoalLevel.task) {
      return false;
    }
    // 如果已完成，不再拆解
    if (goal.status == GoalStatus.completed) {
      return false;
    }
    return true;
  }

  /// 判断目标是否已有子目标（通过传入的 children 列表判断）
  bool hasChildren(List<Goal> allGoals, Goal goal) {
    return allGoals.any((g) => g.parentId == goal.id);
  }

  /// 计算目标的子目标完成进度
  double calculateChildProgress(List<Goal> allGoals, Goal goal) {
    final children = allGoals.where((g) => g.parentId == goal.id).toList();
    if (children.isEmpty) {
      return 0.0;
    }
    final completed = children.where((g) => g.status == GoalStatus.completed).length;
    return completed / children.length;
  }
}