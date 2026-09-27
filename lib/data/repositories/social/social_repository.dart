// lib/data/repositories/social/social_repository.dart

import '../../../core/services/supabase_service.dart';

class SocialRepository {
  SocialRepository({
    SupabaseService? supabase,
  }) : _supabase = supabase ?? SupabaseService();

  final SupabaseService _supabase;

  Future<bool> isFollowing({
    required String targetUserId,
  }) async {
    final currentUserId = _supabase.client.auth.currentUser?.id;

    if (currentUserId == null || currentUserId.isEmpty) {
      return false;
    }

    if (targetUserId.isEmpty) {
      return false;
    }

    final data = await _supabase.client
        .from('follows')
        .select('follower_id')
        .eq('follower_id', currentUserId)
        .eq('following_id', targetUserId)
        .maybeSingle();

    return data != null;
  }

  Future<void> followUser({
    required String targetUserId,
  }) async {
    final currentUserId = _supabase.client.auth.currentUser?.id;

    if (currentUserId == null || currentUserId.isEmpty) {
      throw Exception('用户未登录');
    }

    if (targetUserId.isEmpty) {
      throw Exception('目标用户不能为空');
    }

    if (targetUserId == currentUserId) {
      throw Exception('不能关注自己');
    }

    final alreadyFollowing = await isFollowing(
      targetUserId: targetUserId,
    );

    if (alreadyFollowing) {
      return;
    }

    await _supabase.client.from('follows').insert({
      'follower_id': currentUserId,
      'following_id': targetUserId,
    });
  }

  Future<void> unfollowUser({
    required String targetUserId,
  }) async {
    final currentUserId = _supabase.client.auth.currentUser?.id;

    if (currentUserId == null || currentUserId.isEmpty) {
      throw Exception('用户未登录');
    }

    if (targetUserId.isEmpty) {
      throw Exception('目标用户不能为空');
    }

    await _supabase.client
        .from('follows')
        .delete()
        .eq('follower_id', currentUserId)
        .eq('following_id', targetUserId);
  }
}