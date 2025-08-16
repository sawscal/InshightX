import 'package:flutter/material.dart';
import 'package:news_app/funtions/news_article.dart';
import 'package:news_app/services/InterestProfileService.dart';
import 'package:news_app/services/news_service.dart';

class DynamicInterestSection extends StatefulWidget {
  final String userId;
  final String openAiApiKey;
  final InterestProfileService interestService;
  final NewsService newsService;

  const DynamicInterestSection({
    Key? key,
    required this.userId,
    required this.openAiApiKey,
    required this.interestService,
    required this.newsService,
  }) : super(key: key);

  @override
  State<DynamicInterestSection> createState() => _DynamicInterestSectionState();
}

class _DynamicInterestSectionState extends State<DynamicInterestSection> {
  Map<String, dynamic>? interestProfile;
  List<NewsArticle> articles = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadInterestAndNews();
  }

  Future<void> loadInterestAndNews() async {
    setState(() => loading = true);

    try {
      final profile = await widget.interestService.fetchInterestProfile();

      Map<String, double> weightedInterests = {};
      if (profile.containsKey('weighted_interests')) {
        final data = profile['weighted_interests'] as Map<String, dynamic>;
        data.forEach((key, value) {
          final score = (value as num).toDouble();
          if (score > 0.3) {
            weightedInterests[key] = score;
          }
        });
      }

      final fetchedArticles =
          await widget.newsService.fetchNews(weightedInterests.keys.toList());

      setState(() {
        interestProfile = profile;
        articles = fetchedArticles;
        loading = false;
      });
    } catch (e) {
      print("Error loading interest profile and news: $e");
      setState(() => loading = false);
    }
  }

  void onArticleTap(NewsArticle article) async {
    try {
      await widget.interestService
          .recordInteraction(article.url, article.category);
      await widget.interestService.updateInterestProfile();
      await loadInterestAndNews();
    } catch (e) {
      print("Error recording interaction: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (interestProfile == null || articles.isEmpty) {
      return const Center(child: Text("No interests or articles found"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Interests",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          interestProfile!['user_summary'] ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true, // ✅ Makes ListView work inside Column
          physics: const NeverScrollableScrollPhysics(), // ✅ Prevent scroll conflict
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return ListTile(
              title: Text(article.title),
              subtitle: Text(article.description),
              onTap: () => onArticleTap(article),
            );
          },
        ),
      ],
    );
  }
}
