import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/providers/user_profile_provider.dart';

class JourneyScreen extends ConsumerStatefulWidget {
  const JourneyScreen({super.key});

  @override
  ConsumerState<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends ConsumerState<JourneyScreen> {
  late List<JourneyNode> _nodes;

  void _buildNodes(int currentAge) {
    _nodes = [
      JourneyNode(
        age: currentAge,
        title: '现在',
        subtitle: '${currentAge}岁 · 出发',
        description: '你正在朝着目标努力前行',
        icon: Icons.flag,
        isCurrent: true,
        isCompleted: false,
      ),
      JourneyNode(
        age: 30,
        title: '探索期',
        subtitle: '30岁 · 站稳脚跟',
        description: '建立核心能力，确定长期方向',
        icon: Icons.explore,
        isCurrent: false,
        isCompleted: currentAge >= 30,
      ),
      JourneyNode(
        age: 35,
        title: '积累期',
        subtitle: '35岁 · 加速成长',
        description: '深耕领域，积累资源与人脉',
        icon: Icons.trending_up,
        isCurrent: false,
        isCompleted: currentAge >= 35,
      ),
      JourneyNode(
        age: 40,
        title: '爆发期',
        subtitle: '40岁 · 厚积薄发',
        description: '事业进入快车道，实现跃迁',
        icon: Icons.rocket_launch,
        isCurrent: false,
        isCompleted: currentAge >= 40,
      ),
      JourneyNode(
        age: 50,
        title: '稳定期',
        subtitle: '50岁 · 游刃有余',
        description: '经验丰富，开始带人、传承',
        icon: Icons.anchor,
        isCurrent: false,
        isCompleted: currentAge >= 50,
      ),
      JourneyNode(
        age: 60,
        title: '收获期',
        subtitle: '60岁 · 从容自在',
        description: '享受成果，做自己真正热爱的事',
        icon: Icons.grass,
        isCurrent: false,
        isCompleted: currentAge >= 60,
      ),
      JourneyNode(
        age: 70,
        title: '传承期',
        subtitle: '70岁 · 桃李芬芳',
        description: '把经验和智慧传递给下一代',
        icon: Icons.family_restroom,
        isCurrent: false,
        isCompleted: currentAge >= 70,
      ),
      JourneyNode(
        age: 80,
        title: '回顾期',
        subtitle: '80岁 · 内心丰盈',
        description: '人生圆满，内心平静而强大',
        icon: Icons.auto_stories,
        isCurrent: false,
        isCompleted: currentAge >= 80,
      ),
      JourneyNode(
        age: 90,
        title: '圆满期',
        subtitle: '90岁 · 此生无憾',
        description: '活成了自己想要的样子',
        icon: Icons.star,
        isCurrent: false,
        isCompleted: currentAge >= 90,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 🔥 从 Provider 读取用户档案
    final profile = ref.watch(userProfileProvider);
    final currentAge = profile.age;
    final lifeExpectancy = profile.lifeExpectancy;

    // 构建节点
    _buildNodes(currentAge);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          '成长路线图',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- 顶部进度条 ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '人生进度',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${((currentAge / lifeExpectancy) * 100).toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: currentAge / lifeExpectancy,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      color: Colors.white,
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '你已经走过了 $currentAge 年，还有 ${lifeExpectancy - currentAge} 年的精彩在等你',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 路线图节点 ----------
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✨ 你的人生路线图',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '每一个节点，都是你人生的里程碑',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._buildTimeline(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ---------- 底部激励 ----------
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.emoji_events, color: Color(0xFF1A73E8), size: 28),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '每一步都算数，你正在成为 90 岁时想成为的人',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A73E8),
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeline() {
    final List<Widget> widgets = [];

    for (int i = 0; i < _nodes.length; i++) {
      final node = _nodes[i];

      widgets.add(_buildNode(node));

      // 连接线（最后一个节点不画）
      if (i < _nodes.length - 1) {
        widgets.add(_buildConnector(node.isCompleted || node.isCurrent));
      }
    }

    return widgets;
  }

  Widget _buildNode(JourneyNode node) {
    final isCurrent = node.isCurrent;
    final isCompleted = node.isCompleted;

    Color bgColor;
    Color textColor;
    Color iconBgColor;
    Color borderColor;

    if (isCurrent) {
      bgColor = const Color(0xFF1A73E8);
      textColor = Colors.white;
      iconBgColor = Colors.white;
      borderColor = const Color(0xFF1A73E8);
    } else if (isCompleted) {
      bgColor = const Color(0xFFE8F0FE);
      textColor = const Color(0xFF1A73E8);
      iconBgColor = const Color(0xFF1A73E8);
      borderColor = const Color(0xFF1A73E8);
    } else {
      bgColor = Colors.grey.shade50;
      textColor = Colors.grey.shade400;
      iconBgColor = Colors.grey.shade300;
      borderColor = Colors.grey.shade200;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // 图标
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isCurrent || isCompleted ? iconBgColor : Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Icon(
              node.icon,
              color: isCurrent
                  ? const Color(0xFF1A73E8)
                  : isCompleted
                      ? Colors.white
                      : Colors.grey.shade400,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          // 文字
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      node.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      node.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(isCurrent ? 0.8 : 0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  node.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(isCurrent ? 0.8 : 0.6),
                  ),
                ),
              ],
            ),
          ),
          // 当前标记
          if (isCurrent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '现在',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                ),
              ),
            ),
          if (isCompleted && !isCurrent)
            const Icon(
              Icons.check_circle,
              color: Color(0xFF1A73E8),
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 32,
        width: 2,
        color: isActive ? const Color(0xFF1A73E8) : Colors.grey.shade200,
      ),
    );
  }
}

/// 路线图节点数据模型
class JourneyNode {
  final int age;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final bool isCurrent;
  final bool isCompleted;

  JourneyNode({
    required this.age,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.isCurrent,
    required this.isCompleted,
  });
}