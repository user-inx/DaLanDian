import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/models/goal.dart';
import '../../life_engine/providers/goal_provider.dart';

import 'widgets/greeting_card.dart';
import 'widgets/life_countdown_card.dart';
import 'widgets/goal_card.dart';
import 'widgets/progress_card.dart';
import 'widgets/quote_card.dart';
import 'widgets/coach_card.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      ref.read(goalProvider.notifier).loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Goal> goals = ref.watch(goalProvider);

    final double totalProgress = _calculateTotalProgress(goals);

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
          onRefresh: () {
            return ref.read(goalProvider.notifier).refresh();
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
                  progressValue: totalProgress,
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

  double _calculateTotalProgress(List<Goal> goals) {
    if (goals.isEmpty) {
      return 0.0;
    }

    double total = 0.0;

    for (final Goal goal in goals) {
      total += goal.progress;
    }

    return total / goals.length;
  }
}