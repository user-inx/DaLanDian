import 'package:flutter/material.dart';
import '../models/ai_plan.dart';
import '../data/mock_ai_responses.dart';

class AiCoachScreen extends StatefulWidget {
  final AiPlan plan;
  const AiCoachScreen({super.key, required this.plan});

  @override
  State<AiCoachScreen> createState() => _AiCoachScreenState();
}

class _AiCoachScreenState extends State<AiCoachScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _addMessage(
      'AI',
      '你好！我是你的 AI 人生陪跑教练。\n\n今天的目标是：${widget.plan.goal.title}\n\n今日行动：${widget.plan.todayAction}\n\n告诉我，你今天的执行情况如何？',
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addMessage(String sender, String content) {
    setState(() {
      _messages.add({
        'sender': sender,
        'content': content,
        'timestamp': DateTime.now(),
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty || _isProcessing) return;

    _addMessage('用户', text.trim());
    _inputController.clear();

    setState(() {
      _isProcessing = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        final response = _getAiResponse(text.trim());
        _addMessage('AI', response['message'] as String);
        final suggestion = response['suggestion'];
        if (suggestion != null && suggestion.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              _addMessage('AI', '💡 $suggestion');
            }
          });
        }
        setState(() {
          _isProcessing = false;
        });
      }
    });
  }

  Map<String, String> _getAiResponse(String userInput) {
    final lowerInput = userInput.toLowerCase();

    if (lowerInput.contains('完成') ||
        lowerInput.contains('做到') ||
        lowerInput.contains('做了') ||
        lowerInput.contains('可以')) {
      return MockAiResponses.getCoachResponse(
        userAction: 'completed',
        goalTitle: widget.plan.goal.title,
      );
    } else if (lowerInput.contains('没完成') ||
        lowerInput.contains('没有') ||
        lowerInput.contains('不行') ||
        lowerInput.contains('没做')) {
      return MockAiResponses.getCoachResponse(
        userAction: 'not_completed',
        goalTitle: widget.plan.goal.title,
      );
    } else if (lowerInput.contains('困难') ||
        lowerInput.contains('难') ||
        lowerInput.contains('问题') ||
        lowerInput.contains('怎么办')) {
      return MockAiResponses.getCoachResponse(
        userAction: 'difficulty',
        goalTitle: widget.plan.goal.title,
      );
    } else {
      return MockAiResponses.getCoachResponse(
        userAction: 'default',
        goalTitle: widget.plan.goal.title,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Text(
          'AI 陪跑',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.plan.goal.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '今日行动：${widget.plan.todayAction}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1A73E8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(widget.plan.goal.progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message['sender'] == '用户';
                return _buildMessageBubble(
                  message['content'] as String,
                  isUser,
                  message['timestamp'] as DateTime,
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                _buildQuickButton('完成了', Colors.green),
                const SizedBox(width: 8),
                _buildQuickButton('没完成', Colors.orange),
                const SizedBox(width: 8),
                _buildQuickButton('遇到困难', Colors.red),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    enabled: !_isProcessing,
                    decoration: InputDecoration(
                      hintText: _isProcessing ? 'AI 正在思考...' : '输入你的想法...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isProcessing ? null : () => _sendMessage(_inputController.text),
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send, color: Color(0xFF1A73E8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String content, bool isUser, DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF1A73E8),
              child: const Icon(Icons.auto_awesome, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF1A73E8) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: isUser ? const Radius.circular(12) : const Radius.circular(0),
                  topRight: const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 16, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickButton(String label, Color color) {
    return Expanded(
      child: OutlinedButton(
        onPressed: _isProcessing ? null : () => _sendMessage(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 8),
          side: BorderSide(color: color.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ),
    );
  }
}