// lib/features/for_you/presentation/for_you_feed_screen.dart

import 'package:flutter/material.dart';
import 'package:news_app/funtions/new.dart';
import 'package:news_app/view/home/detail.dart';

class ForYouFeedScreen extends StatefulWidget {
  const ForYouFeedScreen({super.key});

  @override
  State<ForYouFeedScreen> createState() => _ForYouFeedScreenState();
}

class _ForYouFeedScreenState extends State<ForYouFeedScreen> {
  late Future<List<dynamic>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('For You'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<dynamic>>(
        future: futureArticles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No articles found', style: TextStyle(color: Colors.white)));
          }

          final articles = snapshot.data!;

          return ListView.builder(
            itemCount: articles.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                color: Colors.grey[900],
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: article['urlToImage'] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            article['urlToImage'],
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                  title: Text(
                    article['title'] ?? 'No Title',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    article['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Detailscreen(
                          image: article['urlToImage'] ?? '',
                          source: article['source']['name'] ?? 'Unknown',
                          author: article['author'] ?? 'Unknown',
                          title: article['title'] ?? '',
                          description: article['content'] ?? article['description'] ?? '',
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
