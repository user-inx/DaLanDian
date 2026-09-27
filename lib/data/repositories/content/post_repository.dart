import '../../../core/services/supabase_service.dart';
import '../../models/content/post.dart';

class PostRepository {
  final SupabaseService _supabase;

  PostRepository({
    SupabaseService? supabase,
  }) : _supabase = supabase ?? SupabaseService();

  Future<List<Post>> fetchFeed({
    required int tabIndex,
  }) async {
    final client = _supabase.client;
    final currentUserId = client.auth.currentUser?.id;

    // 获取当前用户已经点赞的帖子 ID。
    final likedPostIds = <String>{};

    if (currentUserId != null) {
      final likedRows = await client
          .from('post_likes')
          .select('post_id')
          .eq('user_id', currentUserId);

      for (final row in likedRows) {
        final postId = row['post_id']?.toString();

        if (postId != null && postId.isNotEmpty) {
          likedPostIds.add(postId);
        }
      }
    }

    // 关注页先确定当前用户关注的人。
    List<String> followingIds = [];

    if (tabIndex == 2) {
      if (currentUserId == null) {
        return [];
      }

      final followRows = await client
          .from('follows')
          .select('following_id')
          .eq('follower_id', currentUserId);

      followingIds = followRows
          .map((row) => row['following_id']?.toString())
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toList();

      if (followingIds.isEmpty) {
        return [];
      }
    }

    List<Map<String, dynamic>> rows;

    if (tabIndex == 2) {
      final response = await client
          .from('posts')
          .select(
            'id, author_id, title, content, likes_count, '
            'comments_count, created_at, '
            'post_topics(topics(name))',
          )
          .eq('status', 'published')
          .inFilter('author_id', followingIds)
          .order('created_at', ascending: false);

      rows = List<Map<String, dynamic>>.from(response);
    } else if (tabIndex == 1) {
      final response = await client
          .from('posts')
          .select(
            'id, author_id, title, content, likes_count, '
            'comments_count, created_at, '
            'post_topics(topics(name))',
          )
          .eq('status', 'published')
          .order('likes_count', ascending: false);

      rows = List<Map<String, dynamic>>.from(response);
    } else {
      final response = await client
          .from('posts')
          .select(
            'id, author_id, title, content, likes_count, '
            'comments_count, created_at, '
            'post_topics(topics(name))',
          )
          .eq('status', 'published')
          .order('created_at', ascending: false);

      rows = List<Map<String, dynamic>>.from(response);
    }

    if (rows.isEmpty) {
      return [];
    }

    // 单独查询 profiles，避免 posts -> profiles 的关系缓存问题。
    final authorIds = rows
        .map((row) => row['author_id']?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final authorMap = <String, Map<String, dynamic>>{};

    if (authorIds.isNotEmpty) {
      final profiles = await client
          .from('profiles')
          .select('id, nickname, avatar_url')
          .inFilter('id', authorIds);

      for (final profile in profiles) {
        final id = profile['id']?.toString();

        if (id != null && id.isNotEmpty) {
          authorMap[id] = Map<String, dynamic>.from(profile);
        }
      }
    }

    return rows.map((row) {
      final postId = row['id']?.toString() ?? '';
      final authorId = row['author_id']?.toString() ?? '';
      final profile = authorMap[authorId];

      final postJson = <String, dynamic>{
        ...row,
        'author_name': profile?['nickname'] ?? '大蓝典用户',
        'is_liked': likedPostIds.contains(postId),
      };

      return Post.fromJson(postJson);
    }).toList();
  }

Future<List<Map<String, dynamic>>> fetchTopics() async {
  final response = await _supabase.client
      .from('topics')
      .select('id, name')
      .order('name');

  return List<Map<String, dynamic>>.from(response);
}

Future<void> createPost({
  required String title,
  required String content,
  required String postType,
  required String topicId,
}) async {
    final client = _supabase.client;
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('用户未登录');
    }

    final postResponse = await client
        .from('posts')
        .insert({
'author_id': userId,
'post_type': postType,
'title': title,
'content': content,
        })
        .select('id')
        .single();

    final postId = postResponse['id']?.toString();

    if (postId == null || postId.isEmpty) {
      throw Exception('创建帖子失败');
    }

    await client.from('post_topics').insert({
      'post_id': postId,
      'topic_id': topicId,
    });
  }

  Future<void> likePost({
    required String postId,
  }) async {
    final client = _supabase.client;
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('用户未登录');
    }

    await client.from('post_likes').insert({
      'post_id': postId,
      'user_id': userId,
    });
  }

  Future<void> unlikePost({
    required String postId,
  }) async {
    final client = _supabase.client;
    final userId = client.auth.currentUser?.id;

    if (userId == null) {
      throw Exception('用户未登录');
    }

    await client
        .from('post_likes')
        .delete()
        .eq('post_id', postId)
        .eq('user_id', userId);
  }
}