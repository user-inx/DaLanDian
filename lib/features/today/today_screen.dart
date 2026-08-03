import 'package:flutter/material.dart';

import 'widgets/greeting_card.dart';
import 'widgets/life_countdown_card.dart';
import 'widgets/goal_card.dart';

class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          "今日",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [

              GreetingCard(),

              SizedBox(height: 16),

              LifeCountdownCard(),

              SizedBox(height: 16),

              GoalCard(),

            ],
          ),
        ),
      ),
    );
  }
}