import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/content/post.dart';
import '../../../data/repositories/content/post_repository.dart';

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(),
);

final feedProvider =
    FutureProvider.family<List<Post>, int>((ref, tabIndex) async {
  final repository = ref.read(postRepositoryProvider);

  return repository.fetchFeed(
    tabIndex: tabIndex,
  );
});

final postLikeControllerProvider = Provider<PostLikeController>(
  (ref) => PostLikeController(ref),
);

class PostLikeController {
  final Ref _ref;

  PostLikeController(this._ref);

  Future<void> toggleLike(Post post) async {
    final repository = _ref.read(postRepositoryProvider);

    if (post.isLiked) {
      await repository.unlikePost(
        postId: post.id,
      );
    } else {
      await repository.likePost(
        postId: post.id,
      );
    }

    // 点赞状态和 likes_count 都由数据库负责维护。
    // 操作完成后重新读取三个 Feed。
    _ref.invalidate(feedProvider(0));
    _ref.invalidate(feedProvider(1));
    _ref.invalidate(feedProvider(2));
  }
}