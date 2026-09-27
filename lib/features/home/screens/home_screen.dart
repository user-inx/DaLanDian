import 'package:flutter/material.dart';

import '../widgets/feed_list.dart';
import '../widgets/feed_tab_bar.dart';
import '../widgets/today_topic_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          '大蓝典',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          FeedTabBar(
            currentIndex: _currentTab,
            onChanged: (index) {
              setState(() {
                _currentTab = index;
              });
            },
          ),
          const Divider(
            height: 1,
          ),

          // 今日议题只在「推荐」Tab显示
          if (_currentTab == 0) const TodayTopicCard(),

          Expanded(
            child: FeedList(
              tabIndex: _currentTab,
            ),
          ),
        ],
      ),
    );
  }
}