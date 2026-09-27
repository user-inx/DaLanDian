import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _controllerInitialized = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await ref
          .read(profileUpdateControllerProvider.notifier)
          .updateProfile(
            nickname: _controller.text,
          );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('保存失败：$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);
    final updateState = ref.watch(profileUpdateControllerProvider);
    final isLoading = updateState.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑资料'),
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
          if (profile == null) {
            return const Center(
              child: Text('暂无个人资料'),
            );
          }

          if (!_controllerInitialized) {
            _controller.text = profile.nickname;
            _controllerInitialized = true;
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _controller,
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    labelText: '昵称',
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  child: isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('保存'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}