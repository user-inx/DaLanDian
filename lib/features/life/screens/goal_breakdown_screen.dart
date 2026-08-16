import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../life_engine/providers/goal_provider.dart';
import '../../../life_engine/models/goal.dart';
import '../../../life_engine/enums/goal_status.dart';
import '../../../life_engine/planner/goal_splitter.dart';

class GoalBreakdownScreen extends ConsumerStatefulWidget {
  final String goalId;
  const GoalBreakdownScreen({super.key, required this.goalId});

  @override
  ConsumerState<GoalBreakdownScreen> createState() => _GoalBreakdownScreenState();
}

class _GoalBreakdownScreenState extends ConsumerState<GoalBreakdownScreen> {
  final GoalSplitter _splitter = GoalSplitter();
  bool _isSplitting = false;

  @override
  Widget build(BuildContext context) {
    // ✅ 使用 watch 获取所有目标数据
    final allGoals = ref.watch(goalProvider);
    final notifier = ref.read(goalProvider.notifier);

    // 查找当前目标
    final goal = notifier.findById(widget.goalId);

    if (goal == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          title: const Text(
            '目标拆解',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // ✅ 使用 allGoals（来自 ref.watch）而不是 notifier.state
    final children = allGoals.where((g) => g.parentId == goal.id).toList();
    final hasChildren = children.isNotEmpty;

    final completedChildren = children.where((g) => g.status == GoalStatus.completed).length;
    final childProgress = children.isEmpty ? 0.0 : completedChildren / children.length;
    final totalChildCount = children.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '目标拆解',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (hasChildren)
            TextButton(
              onPressed: _isSplitting ? null : () => _handleReSplit(goal, children),
              child: Text(
                '重新拆解',
                style: TextStyle(
                  color: _isSplitting ? Colors.grey : const Color(0xFF1A73E8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 父目标信息
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (goal.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      goal.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text(
                        '总体进度',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: childProgress,
                            backgroundColor: Colors.grey[200],
                            color: Colors.blue,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${(childProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A73E8),
                        ),
                      ),
                    ],
                  ),
                  if (hasChildren) ...[
                    const SizedBox(height: 4),
                    Text(
                      '$completedChildren / $totalChildCount 已完成',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (hasChildren) ...[
              const Text(
                '子目标',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              ...children.map((child) => _buildChildTile(child, allGoals, notifier)),
            ] else ...[
              // 空状态
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_tree_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '这个目标还没有拆解',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '将大目标拆解成更小、更可执行的子目标',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isSplitting ? null : () => _handleSplit(goal),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A73E8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isSplitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '开始拆解',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChildTile(
    Goal child,
    List<Goal> allGoals,
    GoalNotifier notifier,
  ) {
    final isCompleted = child.status == GoalStatus.completed;
    final hasDeadline = child.deadline != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.green : Colors.grey[200]!,
          width: isCompleted ? 1.5 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: () => _toggleChildStatus(child, notifier),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Colors.green : Colors.transparent,
              border: Border.all(
                color: isCompleted ? Colors.green : Colors.grey[400]!,
                width: 2,
              ),
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        ),
        title: Text(
          child.title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black87,
          ),
        ),
        subtitle: child.description.isNotEmpty
            ? Text(
                child.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasDeadline)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  DateFormat('MM/dd').format(child.deadline!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ),
            Icon(
              isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isCompleted ? Colors.green : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
        onTap: () => _toggleChildStatus(child, notifier),
      ),
    );
  }

  Future<void> _toggleChildStatus(Goal child, GoalNotifier notifier) async {
    final newStatus = child.status == GoalStatus.completed
        ? GoalStatus.waiting
        : GoalStatus.completed;

    final updatedChild = child.copyWith(
      status: newStatus,
      progress: newStatus == GoalStatus.completed ? 1.0 : 0.0,
      completedAt: newStatus == GoalStatus.completed ? DateTime.now() : null,
      updatedAt: DateTime.now(),
    );

    await notifier.updateGoal(updatedChild);
    await _updateParentProgress(notifier, child.parentId);

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _updateParentProgress(GoalNotifier notifier, String? parentId) async {
    if (parentId == null) return;

    final parent = notifier.findById(parentId);
    if (parent == null) return;

    // ✅ 使用 notifier.state 是合理的，因为它在 GoalNotifier 内部
    // 但这里需要获取子目标列表，使用 ref.watch(goalProvider) 获取
    final allGoals = ref.read(goalProvider);
    final children = allGoals.where((g) => g.parentId == parentId).toList();

    if (children.isEmpty) return;

    final completed = children.where((g) => g.status == GoalStatus.completed).length;
    final newProgress = completed / children.length;

    final updatedParent = parent.copyWith(
      progress: newProgress,
      updatedAt: DateTime.now(),
    );

    await notifier.updateGoal(updatedParent);

    if (parent.parentId != null) {
      await _updateParentProgress(notifier, parent.parentId);
    }
  }

  Future<void> _handleSplit(Goal goal) async {
    if (_isSplitting) return;

    setState(() {
      _isSplitting = true;
    });

    try {
      final notifier = ref.read(goalProvider.notifier);

      // ✅ 使用 ref.watch(goalProvider) 而不是 notifier.state
      final allGoals = ref.read(goalProvider);
      final existingChildren = allGoals.where((g) => g.parentId == goal.id).toList();

      if (existingChildren.isNotEmpty) {
        setState(() {
          _isSplitting = false;
        });
        return;
      }

      final children = _splitter.split(
        parentGoal: goal,
        count: 4,
      );

      for (final child in children) {
        await notifier.addGoal(child);
      }

      final updatedGoal = goal.copyWith(
        status: GoalStatus.doing,
        updatedAt: DateTime.now(),
      );
      await notifier.updateGoal(updatedGoal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已生成 ${children.length} 个子目标'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('拆解失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSplitting = false;
        });
      }
    }
  }

  Future<void> _handleReSplit(Goal goal, List<Goal> oldChildren) async {
    if (_isSplitting) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重新拆解'),
        content: Text(
          '重新拆解将删除现有的 ${oldChildren.length} 个子目标，并生成新的子目标。\n\n确定要继续吗？'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('确认重新拆解'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() {
      _isSplitting = true;
    });

    try {
      final notifier = ref.read(goalProvider.notifier);

      for (final child in oldChildren) {
        await notifier.removeGoal(child.id);
      }

      final newChildren = _splitter.split(
        parentGoal: goal,
        count: 4,
      );

      for (final child in newChildren) {
        await notifier.addGoal(child);
      }

      final resetGoal = goal.copyWith(
        progress: 0.0,
        status: GoalStatus.doing,
        updatedAt: DateTime.now(),
      );
      await notifier.updateGoal(resetGoal);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('已重新生成 ${newChildren.length} 个子目标'),
            backgroundColor: Colors.green,
          ),
        );
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('重新拆解失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSplitting = false;
        });
      }
    }
  }
}