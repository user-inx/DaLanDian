import 'package:flutter/material.dart';

import '../discover/discover_page.dart';
import '../home/home_page.dart';
import '../message/message_page.dart';
import '../profile/profile_page.dart';
import '../publish/publish_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int currentIndex = 0;

  final pages = const [
    HomePage(),
    DiscoverPage(),
    PublishPage(),
    MessagePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(

        selectedIndex: currentIndex,

        onDestinationSelected: (index) {

          setState(() {

            currentIndex = index;

          });

        },

        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),

          NavigationDestination(
            icon: Icon(Icons.search),
            label: '发现',
          ),

          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: '发布',
          ),

          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble),
            label: '消息',
          ),

          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),

        ],

      ),

    );

  }
}