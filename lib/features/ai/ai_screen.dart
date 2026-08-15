import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../life_engine/providers/user_profile_provider.dart';
import '../../services/ai_service.dart';

class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [];
  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initWelcomeMessages();
    });
  }

  void _initWelcomeMessages() {
    final profile = ref.read(userProfileProvider);
    _addMessage(
      false,
      '你好！我是阿蓝，以后的路我陪你走 🤝\n\n我了解到你今年 ${profile.age} 岁，在 ${profile.city}，目标是 "${profile.goal}"。\n\n告诉我你今天想聊什么，阿蓝一直都在。',
    );
    _addMessage(
      false,
      '💡 你可以问我任何问题，比如：\n• "今天做什么"\n• "帮我拆解目标"\n• "给我具体可执行的计划"\n• "给我一点鼓励"',
    );
  }

  void _addMessage(bool isUser, String text) {
    setState(() {
      _messages.add({
        'isUser': isUser,
        'text': text,
        'isWaiting': false,
      });
    });
    _scrollToBottom();
  }

  void _addWaitingMessage() {
    setState(() {
      _messages.add({
        'isUser': false,
        'text': '阿蓝正在思考... 🤔',
        'isWaiting': true,
      });
    });
    _scrollToBottom();
  }

  void _removeWaitingMessage() {
    setState(() {
      _messages.removeWhere((msg) => msg['isWaiting'] == true);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isWaiting) return;

    _addMessage(true, text);
    _controller.clear();

    _addWaitingMessage();
    _isWaiting = true;

    try {
      final profile = ref.read(userProfileProvider);

      // 构建历史消息（不包含等待消息）
      final history = _messages
          .where((msg) => msg['isWaiting'] != true)
          .map((msg) => ({
                'isUser': msg['isUser'] as bool,
                'text': msg['text'] as String,
              }))
          .toList();

      // 调用真实 AI API
      final reply = await AIService.chat(
        userMessage: text,
        userProfile: {
          'name': profile.name,
          'age': profile.age,
          'city': profile.city,
          'income': profile.income,
          'dailyFreeHours': profile.dailyFreeHours,
          'goal': profile.goal,
          'lifeExpectancy': profile.lifeExpectancy,
        },
        history: history,
      );

      _removeWaitingMessage();
      _addMessage(false, reply);
    } catch (e) {
      _removeWaitingMessage();
      _addMessage(false, '阿蓝遇到了一点问题，再试一次好吗？ 🙏');
      print('Send message error: $e');
    } finally {
      _isWaiting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Row(
          children: [
            Icon(Icons.smart_toy, color: Color(0xFF1A73E8), size: 24),
            SizedBox(width: 8),
            Text(
              '阿蓝',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              setState(() {
                _messages.clear();
                _isWaiting = false;
              });
              _initWelcomeMessages();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_outlined, size: 60, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          '和阿蓝聊聊天吧',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isUser = msg['isUser'] as bool;
                      final text = msg['text'] as String;
                      final isWaiting = msg['isWaiting'] == true;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment:
                              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: const Color(0xFF1A73E8),
                                child: const Text(
                                  '蓝',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isUser
                                      ? const Color(0xFF1A73E8)
                                      : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(isUser ? 16 : 4),
                                    topRight: Radius.circular(isUser ? 4 : 16),
                                    bottomLeft: const Radius.circular(16),
                                    bottomRight: const Radius.circular(16),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: isWaiting
                                    ? const SizedBox(
                                        height: 24,
                                        child: Row(
                                          children: [
                                            Text(
                                              '阿蓝正在思考',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF1A73E8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Text(
                                        text,
                                        style: TextStyle(
                                          color: isUser ? Colors.white : Colors.black87,
                                          fontSize: 15,
                                          height: 1.6,
                                        ),
                                      ),
                              ),
                            ),
                            if (isUser) ...[
                              const SizedBox(width: 8),
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: Colors.grey.shade300,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),

          if (_messages.isNotEmpty && !_isWaiting)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildQuickChip('今天做什么'),
                    const SizedBox(width: 8),
                    _buildQuickChip('拆解目标'),
                    const SizedBox(width: 8),
                    _buildQuickChip('给我具体可执行的计划'),
                    const SizedBox(width: 8),
                    _buildQuickChip('给我鼓励'),
                  ],
                ),
              ),
            ),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    enabled: !_isWaiting,
                    decoration: InputDecoration(
                      hintText: _isWaiting ? '阿蓝正在思考...' : '和阿蓝说点什么...',
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A73E8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _isWaiting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _isWaiting ? null : _sendMessage,
                    padding: const EdgeInsets.all(8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: GestureDetector(
        onTap: () {
          _controller.text = label;
          _sendMessage();
        },
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1A73E8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}