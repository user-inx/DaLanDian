import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/content_repository.dart';
import '../data/repositories/mock_content_repository.dart';
import '../data/models/content/post.dart';

// 提供 Mock 实例（以后可替换为真实实现）
final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return MockContentRepository();
});

// 获取 Feed 流
final feedProvider = FutureProvider<List<Post>>((ref) async {
  final repo = ref.read(contentRepositoryProvider);
  return repo.getFeed(limit: 50); // 一次加载 50 条
});