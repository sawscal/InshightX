import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/view/home/detail.dart';

class SavedNewsScreen extends StatelessWidget {
  const SavedNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final savedBox = Hive.box<NewsModel>('savedNews');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Saved News', style: GoogleFonts.poppins()),
        backgroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: savedBox.listenable(),
        builder: (context, Box<NewsModel> box, _) {
          final savedNews = box.values.toList();
          if (savedNews.isEmpty) {
            return const Center(
              child: Text("No saved news", style: TextStyle(color: Colors.white)),
            );
          }

          return ListView.builder(
            itemCount: savedNews.length,
            itemBuilder: (context, index) {
              final news = savedNews[index];
              return ListTile(
                title: Text(news.title, style: GoogleFonts.poppins(color: Colors.white)),
                subtitle: Text(news.source, style: const TextStyle(color: Colors.white70)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => news.delete(),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Detailscreen(
                        image: news.image,
                        source: news.source,
                        author: news.author,
                        title: news.title,
                        description: news.description,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
