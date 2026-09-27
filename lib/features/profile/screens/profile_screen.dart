import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 40,
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.email ?? '未登录',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('个人资料'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
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
      ),
    );
  }
}