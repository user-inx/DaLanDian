import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/providers/user_profile_provider.dart';
import 'edit_profile_screen.dart';
import '../auth/providers/auth_provider.dart';  // ← 新增导入

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final Map<String, dynamic> _stats = {
    'totalDays': 45,
    'completedGoals': 3,
    'totalProgress': 60,
    'meditationMinutes': 120,
  };

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '我的',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('设置功能开发中')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- 个人信息卡片 ----------
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1A73E8).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        profile.name[0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${profile.age}岁 · ${profile.city}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 14,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                profile.goal,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: const Color(0xFF1A73E8),
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: const Color(0xFF1A73E8),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 统计卡片 ----------
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.calendar_today,
                    value: '${_stats['totalDays']}天',
                    label: '陪伴天数',
                  ),
                  _buildStatItem(
                    icon: Icons.check_circle_outline,
                    value: '${_stats['completedGoals']}个',
                    label: '已完成目标',
                  ),
                  _buildStatItem(
                    icon: Icons.timeline,
                    value: '${_stats['totalProgress']}%',
                    label: '总进度',
                  ),
                  _buildStatItem(
                    icon: Icons.self_improvement,
                    value: '${_stats['meditationMinutes']}min',
                    label: '冥想时长',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 功能入口 ----------
            Container(
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
                  _buildMenuItem(
                    icon: Icons.edit_note_outlined,
                    title: '编辑人生档案',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                    showDivider: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.emoji_events_outlined,
                    title: '我的徽章',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('徽章功能开发中')),
                      );
                    },
                    showDivider: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.history_outlined,
                    title: '成长记录',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('成长记录功能开发中')),
                      );
                    },
                    showDivider: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.bookmark_outline,
                    title: '我的收藏',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('收藏功能开发中')),
                      );
                    },
                    showDivider: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 关于大蓝典 ----------
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
                children: [
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: '关于大蓝典',
                    onTap: () {
                      _showAboutDialog(context);
                    },
                    showDivider: true,
                  ),
                  _buildMenuItem(
                    icon: Icons.shield_outlined,
                    title: '隐私政策',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('隐私政策开发中')),
                      );
                    },
                    showDivider: true,  // ← 改为 true，在退出登录上方显示分割线
                  ),
                  // 🔥 新增：退出登录
                  _buildMenuItem(
                    icon: Icons.logout_outlined,
                    title: '退出登录',
                    onTap: () {
                      _showSignOutDialog(context);
                    },
                    showDivider: false,
                    isDangerous: true,  // ← 新增参数，用于红色样式
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ---------- 底部版本信息 ----------
            Center(
              child: Text(
                '大蓝典 v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '陪你走到90岁 ✨',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF1A73E8),
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool showDivider,
    bool isDangerous = false,  // ← 新增参数
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: isDangerous ? Colors.red : Colors.grey.shade700,
            size: 22,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              color: isDangerous ? Colors.red : Colors.black87,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: isDangerous ? Colors.red.withOpacity(0.5) : Colors.grey.shade400,
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              color: Colors.grey.shade200,
            ),
          ),
      ],
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('关于大蓝典'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '大蓝典 v1.0.0',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('✨ 陪你走到90岁'),
            SizedBox(height: 8),
            Text(
              '大蓝典是一个AI人生陪跑平台，\n帮助每一位男性更有目标、\n更有行动、更有力量地生活。',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 12),
            Text(
              '💙 今天的每一步，都为了90岁的自己',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1A73E8),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('知道了'),
          ),
        ],
      ),
    );
  }

  // 🔥 新增：退出登录确认对话框
  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认登出'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // 关闭对话框
              await ref.read(authProvider.notifier).signOut();
              // 登出后，app.dart 会自动切换到登录页
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('登出'),
          ),
        ],
      ),
    );
  }
}