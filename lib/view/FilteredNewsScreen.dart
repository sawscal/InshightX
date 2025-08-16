import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilteredNewsScreen extends StatefulWidget {
  final List<String> selectedCategories;

  const FilteredNewsScreen({super.key, required this.selectedCategories});

  @override
  State<FilteredNewsScreen> createState() => _FilteredNewsScreenState();
}

class _FilteredNewsScreenState extends State<FilteredNewsScreen> {
  final List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFilteredNews();
  }

  Future<void> _fetchFilteredNews() async {
    const apiKey = 'YOUR_NEWSAPI_KEY'; // 👈 Replace this
    try {
      List<Map<String, dynamic>> allArticles = [];

      for (String category in widget.selectedCategories) {
        final url =
            'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey';

        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final articles = jsonData['articles'] as List;

          allArticles.addAll(
  articles.map((e) => {...(e as Map<String, dynamic>), 'sourceCategory': category}).toList());

        }
      }

      setState(() {
        _articles.clear();
        _articles.addAll(allArticles);
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching news: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your News Feed')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
                return ListTile(
                  title: Text(article['title'] ?? 'No title'),
                  subtitle: Text('${article['sourceCategory']?.toUpperCase()} • ${article['source']['name'] ?? ''}'),
                  onTap: () {
                    // Optional: open article['url']
                  },
                );
              },
            ),
    );
  }
}
