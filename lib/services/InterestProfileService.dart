import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterestProfileService {
  final FirebaseFirestore firestore;
  final String userId;
  final String openAiApiKey;

  InterestProfileService({
    required this.firestore,
    required this.userId,
    required this.openAiApiKey,
  });

  Future<void> recordInteraction(String articleUrl, String category) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('interactions')
        .add({
      'articleUrl': articleUrl,
      'category': category,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateInterestProfile() async {
    final interactions = await firestore
        .collection('users')
        .doc(userId)
        .collection('interactions')
        .get();

    final Map<String, int> categoryCount = {};

    for (var doc in interactions.docs) {
      final category = doc.data()['category'] ?? 'General';
      categoryCount[category] = (categoryCount[category] ?? 0) + 1;
    }

    final prompt = _buildPrompt(categoryCount);
    final interestProfile = await _callOpenAI(prompt);

    await firestore
        .collection('users')
        .doc(userId)
        .collection('interestProfile')
        .doc('current')
        .set(interestProfile);
  }

  Future<Map<String, dynamic>> fetchInterestProfile() async {
    final doc = await firestore
        .collection('users')
        .doc(userId)
        .collection('interestProfile')
        .doc('current')
        .get();

    if (doc.exists) {
      return doc.data()!;
    } else {
      return {};
    }
  }

  String _buildPrompt(Map<String, int> categoryData) {
    final categoryString =
        categoryData.entries.map((e) => '- ${e.key}: ${e.value}').join('\n');

    return """
You are an AI that generates structured user interest profiles.

Given this user engagement (category: frequency):
$categoryString

Generate a JSON object in this format:
{
  "weighted_interests": {
    "Technology": 0.85,
    "Health": 0.4,
    ...
  },
  "grouped_tags": {
    "Tech & Science": ["AI", "Robotics", "Quantum"],
    ...
  },
  "user_summary": "A tech-savvy user interested in emerging technologies and moderate interest in health and wellness."
}

Only return valid JSON.
""";
  }

  Future<Map<String, dynamic>> _callOpenAI(String prompt) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openAiApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful assistant.'},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final content = jsonDecode(response.body);
      final message = content['choices'][0]['message']['content'];

      try {
        return jsonDecode(message);
      } catch (_) {
        final jsonString = RegExp(r'\{.*\}', dotAll: true).stringMatch(message);
        if (jsonString != null) {
          return jsonDecode(jsonString);
        } else {
          throw Exception('Invalid JSON in OpenAI response');
        }
      }
    } else {
      print('OpenAI error: ${response.body}');
      throw Exception('Failed to get interest profile from OpenAI');
    }
  }
}
