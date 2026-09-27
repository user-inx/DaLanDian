import '../../../core/services/supabase_service.dart';
import '../../models/user/profile.dart';

class ProfileRepository {
  ProfileRepository({
    SupabaseService? supabase,
  }) : _supabase = supabase ?? SupabaseService();

  final SupabaseService _supabase;

  Future<Profile?> getProfile({
    required String userId,
  }) async {
    if (userId.isEmpty) {
      return null;
    }

    final data = await _supabase.client
        .from('profiles')
        .select('id, nickname, avatar_url')
        .eq('id', userId)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return Profile.fromMap(data);
  }

  Future<Profile?> getCurrentProfile() async {
    final currentUserId = _supabase.client.auth.currentUser?.id;

    if (currentUserId == null || currentUserId.isEmpty) {
      return null;
    }

    return getProfile(userId: currentUserId);
  }

  Future<Profile> updateProfile({
    required String nickname,
  }) async {
    final currentUserId = _supabase.client.auth.currentUser?.id;

    if (currentUserId == null || currentUserId.isEmpty) {
      throw Exception('用户未登录');
    }

    final trimmedNickname = nickname.trim();

    if (trimmedNickname.isEmpty) {
      throw Exception('昵称不能为空');
    }

    final data = await _supabase.client
        .from('profiles')
        .update({
          'nickname': trimmedNickname,
        })
        .eq('id', currentUserId)
        .select('id, nickname, avatar_url')
        .single();

    return Profile.fromMap(data);
  }
}