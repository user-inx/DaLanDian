import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/content/comment.dart';
import '../../../data/repositories/content/comment_repository.dart';

final commentRepositoryProvider = Provider<CommentRepository>((ref) {
  return CommentRepository();
});

final commentProvider =
    FutureProvider.autoDispose.family<List<Comment>, String>((ref, postId) {
  final repository = ref.watch(commentRepositoryProvider);

  return repository.fetchComments(
    postId: postId,
  );
});