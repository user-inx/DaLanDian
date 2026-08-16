import 'package:flutter/material.dart';
import '../../data/models/content/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 作者信息
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    post.authorName?.substring(0, 1) ?? 'U',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.authorName ?? '未知用户',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (post.categoryName != null)
                        Text(
                          post.categoryName!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            // 标题
            Text(
              post.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            // 正文摘要
            Text(
              post.body.length > 120 ? '${post.body.substring(0, 120)}...' : post.body,
              style: TextStyle(fontSize: 14, color: Colors.grey[800]),
            ),
            const SizedBox(height: 12),
            // 互动按钮
            Row(
              children: [
                _buildAction(Icons.favorite_border, post.likeCount),
                const SizedBox(width: 20),
                _buildAction(Icons.comment_outlined, post.commentCount),
                const SizedBox(width: 20),
                _buildAction(Icons.share_outlined, post.shareCount),
                const Spacer(),
                _buildAction(Icons.bookmark_border, post.favoriteCount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, int count) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(
          count > 0 ? '$count' : '',
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}