import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class Newsscreen extends StatefulWidget {
  final List<String> selectedCategories;

  const Newsscreen({super.key, required this.selectedCategories});

  @override
  State<Newsscreen> createState() => _NewsscreenState();
}

class _NewsscreenState extends State<Newsscreen> {
  List<Map<String, dynamic>> newsArticles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
                    }

  Future<void> fetchNews() async {
    setState(() {
      isLoading = true;
    });

    const String apiKey = 'YOUR_NEWSAPI_KEY'; // Replace with your API key
    List<Map<String, dynamic>> allArticles = [];

    for (String category in widget.selectedCategories) {
      final url =
          'https://newsapi.org/v2/top-headlines?country=us&category=${category.toLowerCase()}&apiKey=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final articles = jsonData['articles'] as List;

          allArticles.addAll(
            articles.map((e) {
              final article = e as Map<String, dynamic>;
              return {
                ...article,
                'sourceCategory': category,
              };
            }).toList(),
          );
        } else {
          debugPrint('Failed to fetch $category news: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching news for $category: $e');
      }
    }

    setState(() {
      newsArticles = allArticles;
      isLoading = false;
    });
  }

  Future<void> _refreshNews() async {
    await fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your News'),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.notifications),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => const NotificationsScreen(),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshNews,
              child: ListView.builder(
                itemCount: newsArticles.length,
                itemBuilder: (context, index) {
                  final article = newsArticles[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    child: ListTile(
                      leading: article['urlToImage'] != null
                          ? Image.network(
                              article['urlToImage'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image_not_supported),
                      title: Text(
                        article['title'] ?? 'No Title',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        article['description'] ?? 'No Description',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Chip(
                        label: Text(
                          article['sourceCategory'] ?? 'General',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      onTap: () async {
                        final url = article['url'];
                        if (url != null && await canLaunchUrl(Uri.parse(url))) {
                          launchUrl(Uri.parse(url),
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Could not open article URL'),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          );
        }
      }
