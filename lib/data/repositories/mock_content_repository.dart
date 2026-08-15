import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/content/post.dart';
import '../models/content/comment.dart';
import 'content_repository.dart';

class MockContentRepository implements ContentRepository {
  List<Post> _allPosts = [];
  bool _isLoaded = false;

  Future<void> _loadPosts() async {
    if (_isLoaded) return;
    try {
      final String jsonString = await rootBundle.loadString('assets/data/seed_posts.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      _allPosts = jsonList.map((json) => Post.fromJson(json)).toList();
      _allPosts.sort((a, b) => b.publishedAt!.compareTo(a.publishedAt!));
      _isLoaded = true;
    } catch (e) {
      print('加载种子数据失败: $e');
      _allPosts = [];
    }
  }

  @override
  Future<List<Post>> getFeed({String? categoryId, int limit = 20, int offset = 0}) async {
    await _loadPosts();
    List<Post> filtered = _allPosts;
    if (categoryId != null) {
      filtered = filtered.where((p) => p.categoryId == categoryId).toList();
    }
    final start = offset.clamp(0, filtered.length);
    final end = (offset + limit).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  @override
  Future<Post> getPostDetail(String postId) async {
    await _loadPosts();
    final post = _allPosts.firstWhere((p) => p.id == postId);
    return post.copyWith(viewCount: post.viewCount + 1);
  }

  @override
  Future<List<Post>> searchPosts(String query, {int limit = 20}) async {
    await _loadPosts();
    final lowerQuery = query.toLowerCase();
    return _allPosts
        .where((p) => p.title.toLowerCase().contains(lowerQuery) || p.body.toLowerCase().contains(lowerQuery))
        .take(limit)
        .toList();
  }

  @override
  Future<Post> createPost({required String title, required String body, String? coverImage, required String categoryId, List<String>? tagNames}) async {
    return Post(
      id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      coverImage: coverImage,
      authorId: 'mock_user',
      categoryId: categoryId,
      status: 'published',
      sourceType: 'user',
      viewCount: 0,
      likeCount: 0,
      commentCount: 0,
      favoriteCount: 0,
      shareCount: 0,
      publishedAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      authorName: '我',
    );
  }

  @override
  Future<void> toggleLike(String targetId, String targetType) async {
    print('Mock: 切换点赞 $targetType:$targetId');
  }

  @override
  Future<void> toggleFavorite(String postId) async {
    print('Mock: 切换收藏 $postId');
  }

  @override
  Future<void> incrementShareCount(String postId) async {
    print('Mock: 分享计数 $postId');
  }

  @override
  Future<List<Comment>> getComments(String postId, {int limit = 20, int offset = 0}) async {
    return [];
  }

  @override
  Future<Comment> addComment({required String postId, required String content, String? parentId}) async {
    return Comment(
      id: 'mock_comment_${DateTime.now().millisecondsSinceEpoch}',
      content: content,
      postId: postId,
      authorId: 'mock_user',
      parentId: parentId,
      likeCount: 0,
      createdAt: DateTime.now(),
      authorName: '我',
    );
  }

  @override
  Future<void> deleteComment(String commentId) async {
    print('Mock: 删除评论 $commentId');
  }
}