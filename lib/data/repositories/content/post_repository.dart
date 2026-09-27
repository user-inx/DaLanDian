import '../../../core/services/supabase_service.dart';
import '../../models/content/post.dart';

class PostRepository {
  final SupabaseService _supabase = SupabaseService();

  Future<List<Post>> fetchFeed({
    required int tabIndex,
  }) async {
    final client = _supabase.client;

    dynamic query = client
        .from('posts')
        .select('''
          id,
          author_id,
          title,
          content,
          likes_count,
          comments_count,
          created_at,
          post_topics(
            topics(
              name
            )
          )
        ''')
        .eq('status', 'published');

    if (tabIndex == 1) {
      query = query.order(
        'likes_count',
        ascending: false,
      );
    } else if (tabIndex == 2) {
      final userId = client.auth.currentUser?.id;

      if (userId == null) {
        return [];
      }

      final followRows = await client
          .from('follows')
          .select('following_id')
          .eq('follower_id', userId);

      final followedIds = followRows
          .map<String?>(
            (row) => row['following_id']?.toString(),
          )
          .whereType<String>()
          .toList();

      if (followedIds.isEmpty) {
        return [];
      }

      query = query
          .inFilter('author_id', followedIds)
          .order(
            'created_at',
            ascending: false,
          );
    } else {
      query = query.order(
        'created_at',
        ascending: false,
      );
    }

    final rows = await query.limit(20);

    final postRows = List<Map<String, dynamic>>.from(
      rows,
    );

    if (postRows.isEmpty) {
      return [];
    }

    final authorIds = postRows
        .map<String?>(
          (row) => row['author_id']?.toString(),
        )
        .whereType<String>()
        .toSet()
        .toList();

    final profileRows = await client
        .from('profiles')
        .select('id, nickname, avatar_url')
        .inFilter('id', authorIds);

    final profiles = <String, Map<String, dynamic>>{};

    for (final row in profileRows) {
      final profile = Map<String, dynamic>.from(row);

      final id = profile['id']?.toString();

      if (id != null) {
        profiles[id] = profile;
      }
    }

    return postRows.map((row) {
      final authorId = row['author_id']?.toString() ?? '';

      final profile = profiles[authorId];

      final postJson = Map<String, dynamic>.from(row);

      postJson['author_name'] =
          profile?['nickname']?.toString() ?? '大蓝典用户';

      postJson['author_avatar_url'] =
          profile?['avatar_url']?.toString();

      return Post.fromJson(postJson);
    }).toList();
  }

  Future<List<Map<String, dynamic>>> fetchTopics() async {
    final rows = await _supabase.client
        .from('topics')
        .select('id, name, description')
        .order(
          'name',
          ascending: true,
        );

    return List<Map<String, dynamic>>.from(rows);
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

    final postRow = await client
        .from('posts')
        .insert({
          'author_id': userId,
          'post_type': postType,
          'title': title,
          'content': content,
        })
        .select('id')
        .single();

    final postId = postRow['id'].toString();

    await client.from('post_topics').insert({
      'post_id': postId,
      'topic_id': topicId,
    });
  }
}