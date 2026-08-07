import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/providers/goal_provider.dart';

import 'widgets/greeting_card.dart';
import 'widgets/life_countdown_card.dart';
import 'widgets/goal_card.dart';
import 'widgets/progress_card.dart';
import 'widgets/quote_card.dart';
import 'widgets/coach_card.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(goalProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '今日',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(goalProvider.notifier).refresh();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const GreetingCard(),

                const SizedBox(height: 16),

                const LifeCountdownCard(),

                const SizedBox(height: 16),

                const GoalCard(),

                const SizedBox(height: 16),

                ProgressCard(
                  progressValue:
                      ref.watch(goalProvider.notifier).totalProgress,
                ),

                const SizedBox(height: 16),

                const QuoteCard(),

                const SizedBox(height: 16),

                const CoachCard(),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}