class Post {
  final String id;
  final String title;
  final String body;
  final String? coverImage;
  final String authorId;
  final String categoryId;
  final String status;
  final String sourceType;
  final int viewCount;
  final int likeCount;
  final int commentCount;
  final int favoriteCount;
  final int shareCount;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String? authorName;
  final String? authorAvatar;
  final String? categoryName;
  final List<String>? tagNames;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    this.coverImage,
    required this.authorId,
    required this.categoryId,
    required this.status,
    required this.sourceType,
    this.viewCount = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.favoriteCount = 0,
    this.shareCount = 0,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.authorName,
    this.authorAvatar,
    this.categoryName,
    this.tagNames,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      coverImage: json['cover_image'],
      authorId: json['author_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      status: json['status'] ?? 'published',
      sourceType: json['source_type'] ?? 'user',
      viewCount: json['view_count'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      favoriteCount: json['favorite_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
      authorName: json['author_name'],
      authorAvatar: json['author_avatar'],
      categoryName: json['category_name'],
      tagNames: json['tag_names'] != null ? List<String>.from(json['tag_names']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'cover_image': coverImage,
      'author_id': authorId,
      'category_id': categoryId,
      'status': status,
      'source_type': sourceType,
      'view_count': viewCount,
      'like_count': likeCount,
      'comment_count': commentCount,
      'favorite_count': favoriteCount,
      'share_count': shareCount,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Post copyWith({
    String? id,
    String? title,
    String? body,
    String? coverImage,
    String? authorId,
    String? categoryId,
    String? status,
    String? sourceType,
    int? viewCount,
    int? likeCount,
    int? commentCount,
    int? favoriteCount,
    int? shareCount,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? authorName,
    String? authorAvatar,
    String? categoryName,
    List<String>? tagNames,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      coverImage: coverImage ?? this.coverImage,
      authorId: authorId ?? this.authorId,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      sourceType: sourceType ?? this.sourceType,
      viewCount: viewCount ?? this.viewCount,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      shareCount: shareCount ?? this.shareCount,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      categoryName: categoryName ?? this.categoryName,
      tagNames: tagNames ?? this.tagNames,
    );
  }

  @override
  String toString() => 'Post(id: $id, title: $title)';
}