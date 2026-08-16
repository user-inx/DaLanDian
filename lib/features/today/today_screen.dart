import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/greeting_card.dart';
import 'widgets/goal_card.dart';
import 'widgets/coach_card.dart';
import 'widgets/feed_section.dart';
import 'widgets/life_countdown_card.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 顶部留白
          const SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          
          // 1. 欢迎语 + 日期
          const SliverToBoxAdapter(
            child: GreetingCard(),
          ),
          
          // 2. 人生倒计时卡片（可选）
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: LifeCountdownCard(),
            ),
          ),
          
          // 3. 今日目标卡片
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GoalCard(),
            ),
          ),
          
          // 4. AI 陪跑卡片
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CoachCard(),
            ),
          ),
          
          // 5. 推荐内容 Feed
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 16),
              child: FeedSection(),
            ),
          ),
          
          // 底部留白
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}