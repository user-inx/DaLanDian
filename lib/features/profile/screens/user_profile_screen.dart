// lib/features/profile/screens/user_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/supabase_service.dart';
import '../providers/profile_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final SupabaseService _supabase = SupabaseService();

  late final Future<Map<String, dynamic>?> _profileFuture;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _profileFuture = _supabase.client
        .from('profiles')
        .select('id, nickname, avatar_url')
        .eq('id', widget.userId)
        .maybeSingle();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _supabase.client.auth.currentUser?.id;
    final isCurrentUser =
        currentUserId != null && currentUserId == widget.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人主页'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('加载失败：${snapshot.error}'),
            );
          }

          final profile = snapshot.data;

          if (profile == null) {
            return const Center(
              child: Text('用户不存在'),
            );
          }

          final nickname = (profile['nickname'] as String?)?.trim();
          final avatarUrl = profile['avatar_url'] as String?;

          final displayName =
              (nickname == null || nickname.isEmpty) ? '用户' : nickname;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage:
                      (avatarUrl != null && avatarUrl.isNotEmpty)
                          ? NetworkImage(avatarUrl)
                          : null,
                  child: (avatarUrl == null || avatarUrl.isEmpty)
                      ? Text(
                          displayName.isNotEmpty ? displayName[0] : '?',
                          style: const TextStyle(fontSize: 32),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                if (!isCurrentUser) _buildFollowButton(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFollowButton() {
    final followingAsync = ref.watch(userFollowingProvider(widget.userId));
    final controllerState = ref.watch(userFollowControllerProvider);
    final isBusy = _isSubmitting || controllerState.isLoading;

    return followingAsync.when(
      loading: () {
        return const SizedBox(
          width: 96,
          height: 40,
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      error: (error, stackTrace) {
        return OutlinedButton(
          onPressed: isBusy
              ? null
              : () => _toggleFollow(
                    currentlyFollowing: false,
                  ),
          child: const Text('关注'),
        );
      },
      data: (isFollowing) {
        return FilledButton(
          onPressed: isBusy
              ? null
              : () => _toggleFollow(
                    currentlyFollowing: isFollowing,
                  ),
          child: Text(isFollowing ? '已关注' : '关注'),
        );
      },
    );
  }

  Future<void> _toggleFollow({
    required bool currentlyFollowing,
  }) async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(userFollowControllerProvider.notifier).toggleFollow(
            targetUserId: widget.userId,
            currentlyFollowing: currentlyFollowing,
          );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('操作失败：$e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}