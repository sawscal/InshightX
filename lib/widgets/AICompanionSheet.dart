import 'package:flutter/material.dart';
import 'package:news_app/funtions/fetchAIResponse.dart';

class AICompanionSheet extends StatefulWidget {
  final String articleText;
  AICompanionSheet({required this.articleText});

  @override
  _AICompanionSheetState createState() => _AICompanionSheetState();
}

class _AICompanionSheetState extends State<AICompanionSheet> {
  final TextEditingController _controller = TextEditingController();
  String aiResponse = "";

  Future<void> _askAI(String query) async {
    // Here we’ll integrate LLM API call
    final response = await fetchAIResponse(query, widget.articleText);
    setState(() => aiResponse = response);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Ask AI about this news...",
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => _askAI(_controller.text),
              ),
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(aiResponse.isEmpty ? "AI will reply here..." : aiResponse),
            ),
          )
        ],
      ),
    );
  }
}
