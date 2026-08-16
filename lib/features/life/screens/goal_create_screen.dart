import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../life_engine/providers/goal_provider.dart';
import '../../../life_engine/models/goal.dart';
import '../../../life_engine/enums/goal_category.dart';
import '../../../life_engine/enums/goal_level.dart';
import '../../../life_engine/enums/goal_status.dart';

class GoalCreateScreen extends ConsumerStatefulWidget {
  final Goal? editingGoal;

  const GoalCreateScreen({super.key, this.editingGoal});

  @override
  ConsumerState<GoalCreateScreen> createState() => _GoalCreateScreenState();
}

class _GoalCreateScreenState extends ConsumerState<GoalCreateScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _title;
  String _description = '';
  late GoalCategory _category;
  late DateTime _startDate;
  late DateTime _deadline;
  late int _priority;
  late GoalStatus _status;

  bool _isSubmitting = false;

  bool get isEditing => widget.editingGoal != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final goal = widget.editingGoal!;
      _title = goal.title;
      _description = goal.description;
      _category = goal.category;
      _startDate = goal.createdAt;
      _deadline = goal.deadline ?? DateTime.now().add(const Duration(days: 30));
      _priority = goal.priority;
      _status = goal.status;
    } else {
      _title = '';
      _description = '';
      _category = GoalCategory.health;
      _startDate = DateTime.now();
      _deadline = DateTime.now().add(const Duration(days: 30));
      _priority = 2;
      _status = GoalStatus.doing;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: Text(
          isEditing ? '编辑目标' : '创建目标',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : _submit,
            child: Text(
              isEditing ? '保存' : '创建',
              style: TextStyle(
                color: _isSubmitting ? Colors.grey : const Color(0xFF1A73E8),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 目标名称
              _buildTextField(
                label: '目标名称 *',
                hint: '输入目标名称，如：减重10斤',
                initialValue: isEditing ? _title : null,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入目标名称';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!.trim(),
              ),
              const SizedBox(height: 16),

              // 目标描述
              _buildTextField(
                label: '目标描述',
                hint: '描述你的目标（可选）',
                maxLines: 3,
                initialValue: isEditing ? _description : null,
                validator: null,
                onSaved: (value) => _description = value?.trim() ?? '',
              ),
              const SizedBox(height: 16),

              // 分类
              _buildCategorySelector(),
              const SizedBox(height: 16),

              // 开始日期
              _buildDateField(
                label: '开始日期',
                value: _startDate,
                onTap: () => _selectDate(context, isStart: true),
              ),
              const SizedBox(height: 16),

              // 截止日期
              _buildDateField(
                label: '截止日期 *',
                value: _deadline,
                onTap: () => _selectDate(context, isStart: false),
              ),
              const SizedBox(height: 16),

              // 优先级
              _buildPrioritySelector(),
              const SizedBox(height: 16),

              // 状态（仅在编辑模式下显示）
              if (isEditing) ...[
                _buildStatusSelector(),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? hint,
    int maxLines = 1,
    String? initialValue,
    String? Function(String?)? validator,
    required void Function(String?) onSaved,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          maxLines: maxLines,
          initialValue: initialValue,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1A73E8)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          validator: validator,
          onSaved: onSaved,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    final categories = [
      GoalCategory.health,
      GoalCategory.career,
      GoalCategory.wealth,
      GoalCategory.family,
      GoalCategory.learning,
      GoalCategory.social,
      GoalCategory.hobby,
      GoalCategory.spiritual,
    ];

    final labels = {
      GoalCategory.health: '健康',
      GoalCategory.career: '事业',
      GoalCategory.wealth: '财务',
      GoalCategory.family: '家庭',
      GoalCategory.learning: '学习',
      GoalCategory.social: '社交',
      GoalCategory.hobby: '兴趣',
      GoalCategory.spiritual: '灵性',
    };

    final icons = {
      GoalCategory.health: '💪',
      GoalCategory.career: '💼',
      GoalCategory.wealth: '💰',
      GoalCategory.family: '👨‍👩‍👧‍👦',
      GoalCategory.learning: '📚',
      GoalCategory.social: '🤝',
      GoalCategory.hobby: '🎨',
      GoalCategory.spiritual: '🧘',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '分类 *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories.map((category) {
            final isSelected = _category == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _category = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1A73E8) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF1A73E8) : Colors.grey[300]!,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      icons[category] ?? '🎯',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      labels[category] ?? '未知',
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy年MM月dd日').format(value),
                  style: const TextStyle(fontSize: 14),
                ),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrioritySelector() {
    final priorities = [
      {'label': '低', 'value': 1, 'color': Colors.green},
      {'label': '中', 'value': 2, 'color': Colors.orange},
      {'label': '高', 'value': 3, 'color': Colors.red},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '优先级',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: priorities.map((item) {
            final isSelected = _priority == item['value'];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _priority = item['value'] as int;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (item['color'] as Color).withOpacity(0.15)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? (item['color'] as Color)
                            : Colors.grey[300]!,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item['label'] as String,
                        style: TextStyle(
                          color: isSelected
                              ? item['color'] as Color
                              : Colors.grey[600],
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSelector() {
    final statuses = [
      GoalStatus.waiting,
      GoalStatus.doing,
      GoalStatus.completed,
      GoalStatus.failed,
    ];

    final labels = {
      GoalStatus.waiting: '等待中',
      GoalStatus.doing: '进行中',
      GoalStatus.completed: '已完成',
      GoalStatus.failed: '已失败',
    };

    final colors = {
      GoalStatus.waiting: Colors.grey,
      GoalStatus.doing: Colors.orange,
      GoalStatus.completed: Colors.green,
      GoalStatus.failed: Colors.red,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '状态',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: statuses.map((status) {
            final isSelected = _status == status;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _status = status;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? colors[status]?.withOpacity(0.15) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? colors[status]! : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  labels[status] ?? '未知',
                  style: TextStyle(
                    color: isSelected ? colors[status] : Colors.black87,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, {required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _deadline,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A73E8),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_deadline.isBefore(_startDate)) {
            _deadline = _startDate.add(const Duration(days: 30));
          }
        } else {
          _deadline = picked;
        }
      });
    }
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    if (_deadline.isBefore(_startDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('截止日期必须晚于开始日期'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (isEditing) {
        // 编辑模式：更新现有目标
        final updatedGoal = widget.editingGoal!.copyWith(
          title: _title,
          description: _description,
          category: _category,
          deadline: _deadline,
          priority: _priority,
          status: _status,
          updatedAt: DateTime.now(),
        );

        await ref.read(goalProvider.notifier).updateGoal(updatedGoal);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('目标已更新！✅'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } else {
        // 创建模式
        final newGoal = Goal(
          id: const Uuid().v4(),
          parentId: null,
          title: _title,
          description: _description,
          level: GoalLevel.goal,
          category: _category,
          status: GoalStatus.doing,
          priority: _priority,
          estimatedMinutes: 0,
          progress: 0.0,
          deadline: _deadline,
          completedAt: null,
          createdAt: _startDate,
          updatedAt: DateTime.now(),
        );

        await ref.read(goalProvider.notifier).addGoal(newGoal);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('目标创建成功！🎉'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('操作失败: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}