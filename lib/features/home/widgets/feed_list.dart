import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/feed_provider.dart';
import 'post_card.dart';

class FeedList extends ConsumerWidget {
  final int tabIndex;

  const FeedList({
    super.key,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedAsync = ref.watch(
      feedProvider(tabIndex),
    );

    return feedAsync.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, stackTrace) {
        debugPrint('========== FEED ERROR ==========');
        debugPrint('tabIndex: $tabIndex');
        debugPrint('error: $error');
        debugPrint('stackTrace: $stackTrace');
        debugPrint('=================================');

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '加载失败\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(
            child: Text(
              '暂时没有内容',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(
              feedProvider(tabIndex),
            );

            await ref.read(
              feedProvider(tabIndex).future,
            );
          },
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];

              return PostCard(
                username: post.authorName,
                title: post.title,
                content: post.content,
                topic: post.topicName,
                likes: post.likesCount,
                comments: post.commentsCount,
              );
            },
          ),
        );
      },
    );
  }
}