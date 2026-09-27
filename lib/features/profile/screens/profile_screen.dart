import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../providers/profile_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '我的',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: profileAsync.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('资料加载失败'),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(currentProfileProvider);
                  },
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        },
        data: (profile) {
          final avatarUrl = profile?.avatarUrl;
          final nickname = profile?.nickname ?? '用户';
          final email = user?.email ?? '未登录';

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? NetworkImage(avatarUrl)
                          : null,
                  child: (avatarUrl == null || avatarUrl.isEmpty)
                      ? const Icon(
                          Icons.person,
                          size: 40,
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  nickname,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 40),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('个人资料'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                    if (context.mounted) {
                      ref.invalidate(currentProfileProvider);
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: const Text('我的目标'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('设置'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () async {
                    await ref.read(authProvider.notifier).signOut();
                  },
                  child: const Text('退出登录'),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}