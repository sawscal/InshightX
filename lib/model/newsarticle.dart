class NewsArticle {
  final String title;
  final String description;
  final String url;
  final String category;

  NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.category,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json, String category) {
    return NewsArticle(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      category: category,
    );
  }
}
