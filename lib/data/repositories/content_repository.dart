import '../models/content/post.dart';
import '../models/content/comment.dart';

abstract class ContentRepository {
  Future<List<Post>> getFeed({
    String? categoryId,
    int limit = 20,
    int offset = 0,
  });

  Future<Post> getPostDetail(String postId);

  Future<List<Post>> searchPosts(String query, {int limit = 20});

  Future<Post> createPost({
    required String title,
    required String body,
    String? coverImage,
    required String categoryId,
    List<String>? tagNames,
  });

  Future<void> toggleLike(String targetId, String targetType);

  Future<void> toggleFavorite(String postId);

  Future<void> incrementShareCount(String postId);

  Future<List<Comment>> getComments(String postId, {int limit = 20, int offset = 0});

  Future<Comment> addComment({
    required String postId,
    required String content,
    String? parentId,
  });

  Future<void> deleteComment(String commentId);
}