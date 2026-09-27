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