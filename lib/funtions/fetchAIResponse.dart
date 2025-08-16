import 'dart:convert';

import 'package:http/http.dart' as http;

Future<String> fetchAIResponse(String query, String articleText) async {
  final body = {
    "prompt": "User question: $query\nArticle: $articleText\nAnswer:",
  };

  final res = await http.post(
    Uri.parse("https://your-llm-backend/api"),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(body),
  );

  return jsonDecode(res.body)["answer"];
}
