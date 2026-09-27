import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/content/comment.dart';

class CommentRepository {
  final SupabaseClient _client;

  CommentRepository({
    SupabaseClient? client,
  }) : _client = client ?? Supabase.instance.client;

  Future<List<Comment>> fetchComments({
    required String postId,
  }) async {
    final response = await _client
        .from('comments')
        .select(
          'id, content, post_id, author_id, parent_id, '
          'like_count, created_at',
        )
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    final rows = List<Map<String, dynamic>>.from(response);

    if (rows.isEmpty) {
      return [];
    }

    final authorIds = rows
        .map((row) => row['author_id']?.toString())
        .whereType<String>()
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList();

    final authorMap = <String, Map<String, dynamic>>{};

    if (authorIds.isNotEmpty) {
      final profiles = await _client
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
      final authorId = row['author_id']?.toString() ?? '';
      final profile = authorMap[authorId];

      return Comment.fromJson({
        ...row,
        'author_name': profile?['nickname'],
        'author_avatar': profile?['avatar_url'],
      });
    }).toList();
  }

  Future<Comment> createComment({
    required String postId,
    required String content,
    String? parentId,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception('请先登录后再评论');
    }

    final response = await _client
        .from('comments')
        .insert({
          'post_id': postId,
          'author_id': user.id,
          'content': content,
          'parent_id': parentId,
        })
        .select(
          'id, content, post_id, author_id, parent_id, '
          'like_count, created_at',
        )
        .single();

    final profile = await _client
        .from('profiles')
        .select('id, nickname, avatar_url')
        .eq('id', user.id)
        .maybeSingle();

    return Comment.fromJson({
      ...response,
      'author_name': profile?['nickname'],
      'author_avatar': profile?['avatar_url'],
    });
  }
}