import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/providers/user_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _cityController;
  late TextEditingController _incomeController;
  late TextEditingController _hoursController;
  late TextEditingController _goalController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);

    _nameController = TextEditingController(text: profile.name);
    _ageController = TextEditingController(text: profile.age.toString());
    _cityController = TextEditingController(text: profile.city);
    _incomeController = TextEditingController(text: profile.income.toString());
    _hoursController = TextEditingController(text: profile.dailyFreeHours.toString());
    _goalController = TextEditingController(text: profile.goal);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _incomeController.dispose();
    _hoursController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final age = int.parse(_ageController.text.trim());
    final city = _cityController.text.trim();
    final income = int.parse(_incomeController.text.trim());
    final hours = int.parse(_hoursController.text.trim());
    final goal = _goalController.text.trim();

    // 🔥 更新 Provider
    ref.read(userProfileNotifierProvider).updateProfile(
          name: name,
          age: age,
          city: city,
          income: income,
          dailyFreeHours: hours,
          goal: goal,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ 人生档案已更新'),
        backgroundColor: Color(0xFF2E7D32),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '编辑人生档案',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              '保存',
              style: TextStyle(
                color: Color(0xFF1A73E8),
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
              // ---------- 说明 ----------
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F0FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF1A73E8), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '填写你的真实信息，阿蓝会根据这些信息为你定制专属成长计划',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1A73E8),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ---------- 表单 ----------
              _buildTextField(
                controller: _nameController,
                label: '姓名',
                icon: Icons.person_outline,
                hint: '你的名字',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入姓名';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _ageController,
                label: '年龄',
                icon: Icons.cake_outlined,
                hint: '例如 28',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入年龄';
                  }
                  final age = int.tryParse(value.trim());
                  if (age == null || age < 1 || age > 120) {
                    return '请输入有效年龄（1-120）';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _cityController,
                label: '所在城市',
                icon: Icons.location_city_outlined,
                hint: '例如 新加坡',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入所在城市';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _incomeController,
                label: '月收入（美元）',
                icon: Icons.monetization_on_outlined,
                hint: '例如 8000',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入月收入';
                  }
                  final income = int.tryParse(value.trim());
                  if (income == null || income < 0) {
                    return '请输入有效数字';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _hoursController,
                label: '每日自由时间（小时）',
                icon: Icons.access_time_outlined,
                hint: '例如 2',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入每日自由时间';
                  }
                  final hours = int.tryParse(value.trim());
                  if (hours == null || hours < 0 || hours > 24) {
                    return '请输入 0-24 之间的数字';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildTextField(
                controller: _goalController,
                label: '人生目标',
                icon: Icons.flag_outlined,
                hint: '例如 3年内实现年收入100万',
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '请输入你的人生目标';
                  }
                  if (value.trim().length < 3) {
                    return '目标至少3个字';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ---------- 保存按钮 ----------
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A73E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '保存档案',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey.shade500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}