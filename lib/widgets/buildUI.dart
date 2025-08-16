import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  final List<Content> _chatHistory = [
    Content(
      role: 'user',
      parts: [
        TextPart(
          "You are NewsBot, an AI that answers only news-related questions. "
          "Do not say you lack real-time info. Instead, give summaries about current events, "
          "politics, sports, tech, economy, or global news based on your training data. "
          "Avoid general replies like 'check the internet' and try to help with detailed answers.",
        ),
      ],
    )
  ];

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _isLoading = true;
    });

    _chatHistory.add(Content(role: 'user', parts: [TextPart(text)]));

    try {
      final response = await Gemini.instance.chat(_chatHistory);

      final reply = (response?.output is List && (response?.output?.isNotEmpty ?? false))
          ? (response?.output as List).first ?? "🤖 No response."
          : (response?.output is String && (response?.output?.isNotEmpty ?? false))
              ? response?.output
              : (response?.content?.parts is List && (response?.content?.parts?.isNotEmpty ?? false))
                  ? (response?.content?.parts as List).first.toString() ?? "🤖 No response."
                  : "🤖 No response.";

      setState(() {
        _messages.add({"role": "ai", "text": reply});
        _chatHistory.add(Content(role: 'model', parts: [TextPart(reply)]));
        _isLoading = false;
        _controller.clear();
      });

      // ✅ Auto scroll to bottom
      Future.delayed(const Duration(milliseconds: 200), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "role": "ai",
          "text": "❌ Error: $e"
        });
        _isLoading = false;
      });
    }
  }

  Widget _buildBubble(String text, bool isUser) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      padding: const EdgeInsets.all(12),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      decoration: BoxDecoration(
        color: isUser ? Colors.blue : Colors.grey.shade200,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(12),
          topRight: const Radius.circular(12),
          bottomLeft: Radius.circular(isUser ? 12 : 0),
          bottomRight: Radius.circular(isUser ? 0 : 12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(color: isUser ? Colors.white : Colors.black87),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📰 NewsBot'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _chatHistory.removeRange(1, _chatHistory.length); // keep system prompt
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isLoading && index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircularProgressIndicator(strokeWidth: 2),
                        SizedBox(width: 10),
                        Text("NewsBot is typing..."),
                      ],
                    ),
                  );
                }

                final message = _messages[index];
                return _buildBubble(message["text"], message["role"] == "user");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: const InputDecoration(
                      hintText: "Ask about news, current events, etc...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _controller.text.trim().isEmpty || _isLoading
                      ? null
                      : () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
