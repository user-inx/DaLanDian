import 'package:flutter/material.dart';

class FeedTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const FeedTabBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  static const tabs = [
    '推荐',
    '热门',
    '关注',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: List.generate(
          tabs.length,
          (index) {
            final selected = index == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => onChanged(index),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}