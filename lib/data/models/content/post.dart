class Post {
  final String id;
  final String authorId;
  final String authorName;
  final String title;
  final String content;
  final String topicName;
  final int likesCount;
  final int commentsCount;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.topicName,
    required this.likesCount,
    required this.commentsCount,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    String topicName = '大蓝典';

    final postTopics = json['post_topics'];

    if (postTopics is List && postTopics.isNotEmpty) {
      final first = postTopics.first;

      if (first is Map<String, dynamic>) {
        final topic = first['topics'];

        if (topic is Map<String, dynamic>) {
          topicName =
              topic['name']?.toString() ?? '大蓝典';
        }
      }
    }

    return Post(
      id: json['id']?.toString() ?? '',
      authorId: json['author_id']?.toString() ?? '',
      authorName:
          json['author_name']?.toString() ?? '大蓝典用户',
      title: json['title']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      topicName: topicName,
      likesCount:
          (json['likes_count'] as num?)?.toInt() ?? 0,
      commentsCount:
          (json['comments_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse(
            json['created_at']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}