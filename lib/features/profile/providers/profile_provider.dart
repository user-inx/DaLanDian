// lib/features/profile/providers/profile_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/user/profile.dart';
import '../../../data/repositories/social/social_repository.dart';
import '../../../data/repositories/user/profile_repository.dart';
import '../../home/providers/feed_provider.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});

final currentProfileProvider = FutureProvider<Profile?>((ref) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getCurrentProfile();
});

final userProfileProvider =
    FutureProvider.family<Profile?, String>((ref, userId) async {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfile(userId: userId);
});

final userFollowingProvider = FutureProvider.family<bool, String>(
  (ref, targetUserId) async {
    final repository = ref.watch(socialRepositoryProvider);

    return repository.isFollowing(
      targetUserId: targetUserId,
    );
  },
);

final userFollowControllerProvider =
    StateNotifierProvider<UserFollowController, AsyncValue<void>>((ref) {
  return UserFollowController(ref);
});

class UserFollowController extends StateNotifier<AsyncValue<void>> {
  UserFollowController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<void> toggleFollow({
    required String targetUserId,
    required bool currentlyFollowing,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(socialRepositoryProvider);

      if (currentlyFollowing) {
        await repository.unfollowUser(targetUserId: targetUserId);
      } else {
        await repository.followUser(targetUserId: targetUserId);
      }

      _ref.invalidate(userFollowingProvider(targetUserId));

      _ref.invalidate(feedProvider(0));
      _ref.invalidate(feedProvider(1));
      _ref.invalidate(feedProvider(2));

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

final profileUpdateControllerProvider =
    StateNotifierProvider<ProfileUpdateController, AsyncValue<Profile?>>(
  (ref) {
    return ProfileUpdateController(ref);
  },
);

class ProfileUpdateController
    extends StateNotifier<AsyncValue<Profile?>> {
  ProfileUpdateController(this._ref)
      : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<Profile> updateProfile({
    required String nickname,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = _ref.read(profileRepositoryProvider);

      final profile = await repository.updateProfile(
        nickname: nickname,
      );

      _ref.invalidate(currentProfileProvider);

      state = AsyncValue.data(profile);

      return profile;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}