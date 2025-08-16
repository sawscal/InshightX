

import 'package:hive/hive.dart';

part 'news_model.g.dart';

@HiveType(typeId: 0)
class NewsModel extends HiveObject {
  @HiveField(0)
  String image;

  @HiveField(1)
  String source;

  @HiveField(2)
  String author;

  @HiveField(3)
  String title;

  @HiveField(4)
  String description;

  NewsModel({
    required this.image,
    required this.source,
    required this.author,
    required this.title,
    required this.description,
  });
}
