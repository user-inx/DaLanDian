class Comment {
  final String id;
  final String content;
  final String postId;
  final String authorId;
  final String? parentId;
  final int likeCount;
  final DateTime createdAt;
  final String? authorName;
  final String? authorAvatar;

  const Comment({
    required this.id,
    required this.content,
    required this.postId,
    required this.authorId,
    this.parentId,
    this.likeCount = 0,
    required this.createdAt,
    this.authorName,
    this.authorAvatar,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      postId: json['post_id'] ?? '',
      authorId: json['author_id'] ?? '',
      parentId: json['parent_id'],
      likeCount: json['like_count'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      authorName: json['author_name'],
      authorAvatar: json['author_avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'post_id': postId,
      'author_id': authorId,
      'parent_id': parentId,
      'like_count': likeCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}