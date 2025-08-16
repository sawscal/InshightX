import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/funtions/news_article.dart';


class NewsService {
  final String apiKey = 'YOUR_NEWSAPI_KEY'; // Replace with your key

  Future<List<NewsArticle>> fetchNews(List<String> categories) async {
    List<NewsArticle> allArticles = [];

    for (String category in categories) {
      final url =
          'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final articles = jsonData['articles'] as List;

        allArticles.addAll(
          articles
              .map((e) => NewsArticle.fromJson(e as Map<String, dynamic>, category))
              .toList(),
        );
      }
    }

    return allArticles;
  }
}
