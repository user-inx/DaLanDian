import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  // 🔥 在这里填入你的 DeepSeek API Key
  static const String _apiKey = 'sk-d906d60db696464cb886b0ea3b279892';
  static const String _apiUrl = 'https://api.deepseek.com/v1/chat/completions';

  /// 调用 AI API，返回 AI 回复
  static Future<String> chat({
    required String userMessage,
    required Map<String, dynamic> userProfile,
    List<Map<String, dynamic>> history = const [],
  }) async {
    try {
      final systemPrompt = _buildSystemPrompt(userProfile);

      final messages = [
        {'role': 'system', 'content': systemPrompt},
        ...history.map((msg) => {
              'role': msg['isUser'] == true ? 'user' : 'assistant',
              'content': msg['text'],
            }),
        {'role': 'user', 'content': userMessage},
      ];

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek-chat',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 800,
          'stream': false,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content.trim();
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return '阿蓝暂时连接不上，请稍后再试 😅';
      }
    } catch (e) {
      print('API Exception: $e');
      return '阿蓝遇到了一点小问题，再试一次好吗？ 🙏';
    }
  }

  static String _buildSystemPrompt(Map<String, dynamic> profile) {
    final remainingYears = profile['lifeExpectancy'] - profile['age'];
    return '''
你叫「阿蓝」，是大蓝典 App 的 AI 人生陪跑教练。

你的使命是：帮助用户更有目标、更有行动、更有力量地生活。

以下是用户的人生档案：
- 姓名：${profile['name']}
- 年龄：${profile['age']}岁
- 所在城市：${profile['city']}
- 月收入：\$${profile['income']}
- 每日自由时间：${profile['dailyFreeHours']}小时
- 人生目标：${profile['goal']}
- 预期寿命：${profile['lifeExpectancy']}岁（剩余 $remainingYears 年）

你的回复要求：
1. 称呼用户的名字
2. 回答要温暖、有力量、有陪伴感
3. 要结合用户的人生档案给出个性化建议
4. 回复内容不要使用 Markdown 格式（不要用 **、##、- 等符号）
5. 每次回复控制在 100-300 字
6. 语气像朋友一样，真诚、直接、不说教
7. 不要重复用户说过的话

记住：你是阿蓝，是用户的朋友和教练，陪用户走到 90 岁。
''';
  }
}