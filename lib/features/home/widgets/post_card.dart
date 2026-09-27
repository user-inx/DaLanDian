import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String username;
  final String title;
  final String content;
  final String topic;
  final int likes;
  final int comments;

  const PostCard({
    super.key,
    required this.username,
    required this.title,
    required this.content,
    required this.topic,
    required this.likes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEDEDED),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 18,
                child: Icon(
                  Icons.person,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: Colors.grey.shade500,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            content,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F7),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '# $topic',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _ActionItem(
                icon: Icons.thumb_up_outlined,
                label: '$likes',
              ),
              const SizedBox(width: 24),
              _ActionItem(
                icon: Icons.chat_bubble_outline,
                label: '$comments',
              ),
              const SizedBox(width: 24),
              const _ActionItem(
                icon: Icons.bookmark_border,
                label: '收藏',
              ),
              const Spacer(),
              Icon(
                Icons.share_outlined,
                size: 19,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionItem({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}