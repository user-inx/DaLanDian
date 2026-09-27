import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/content/comment.dart';
import '../../../data/models/content/post.dart';
import '../providers/comment_provider.dart';

class PostDetailScreen extends ConsumerStatefulWidget {
  final Post post;

  const PostDetailScreen({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<PostDetailScreen> createState() =>
      _PostDetailScreenState();
}

class _PostDetailScreenState
    extends ConsumerState<PostDetailScreen> {
  final TextEditingController _commentController =
      TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment() async {
    final content = _commentController.text.trim();

    if (content.isEmpty) {
      return;
    }

    if (content.length > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('评论不能超过 500 个字'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final repository =
          ref.read(commentRepositoryProvider);

      await repository.createComment(
        postId: widget.post.id,
        content: content,
      );

      _commentController.clear();

      ref.invalidate(
        commentProvider(widget.post.id),
      );

      if (mounted) {
        FocusScope.of(context).unfocus();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('评论成功'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('评论失败：$e'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync =
        ref.watch(commentProvider(widget.post.id));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          '帖子',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(
  commentProvider(widget.post.id),
);

await ref.read(
  commentProvider(widget.post.id).future,
);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  32,
                ),
                children: [
                  _buildPostContent(),
                  const SizedBox(height: 28),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildCommentHeader(
                    commentsAsync,
                  ),
                  const SizedBox(height: 12),
                  _buildComments(commentsAsync),
                ],
              ),
            ),
          ),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              child: Icon(
                Icons.person,
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.post.authorName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.post.title,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.post.content,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade800,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 9,
            vertical: 5,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F7),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '# ${widget.post.topicName}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Divider(),
        const SizedBox(height: 12),
        Row(
          children: [
            _StatItem(
              icon: Icons.thumb_up_outlined,
              label: '${widget.post.likesCount}',
            ),
            const SizedBox(width: 28),
            _StatItem(
              icon: Icons.chat_bubble_outline,
              label: '${widget.post.commentsCount}',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentHeader(
    AsyncValue<List<Comment>> commentsAsync,
  ) {
    return commentsAsync.when(
      data: (comments) {
        return Text(
          '评论 ${comments.length}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      },
      loading: () {
        return const Text(
          '评论',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      },
      error: (_, _) {
        return const Text(
          '评论',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget _buildComments(
    AsyncValue<List<Comment>> commentsAsync,
  ) {
    return commentsAsync.when(
      loading: () {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (error, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 24,
          ),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 36,
                color: Colors.grey.shade500,
              ),
              const SizedBox(height: 8),
              Text(
                '评论加载失败',
                style: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  ref.invalidate(
                    commentProvider(widget.post.id),
                  );
                },
                child: const Text('重新加载'),
              ),
            ],
          ),
        );
      },
      data: (comments) {
        if (comments.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
            ),
            child: Center(
              child: Text(
                '还没有评论，来发表第一条评论吧',
                style: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          );
        }

        return Column(
          children: comments.map(_buildCommentItem).toList(),
        );
      },
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 17,
            backgroundImage:
                comment.authorAvatar != null &&
                        comment.authorAvatar!.isNotEmpty
                    ? NetworkImage(
                        comment.authorAvatar!,
                      )
                    : null,
            child: comment.authorAvatar == null ||
                    comment.authorAvatar!.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 18,
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  comment.authorName?.isNotEmpty == true
                      ? comment.authorName!
                      : '大蓝典用户',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  comment.content,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _formatCommentTime(
                    comment.createdAt,
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          8,
          12,
          8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                minLines: 1,
                maxLines: 4,
                maxLength: 500,
                textInputAction:
                    TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: '说点什么...',
                  counterText: '',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed:
                  _isSubmitting ? null : _submitComment,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.send,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCommentTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '刚刚';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分钟前';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours}小时前';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays}天前';
    }

    return '${time.year}-${time.month.toString().padLeft(2, '0')}-'
        '${time.day.toString().padLeft(2, '0')}';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 19,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}