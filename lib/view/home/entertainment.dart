import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/funtions/new.dart';
import 'package:news_app/view/home/detail.dart';

class Entertainment extends StatelessWidget {
  const Entertainment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<dynamic>>(
        future: fetchentertainment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading news'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available'));
          } else {
            final newsTitles = snapshot.data!;
            return ListView.builder(
              itemCount: newsTitles.length,
              itemBuilder: (context, index) {
                final news = newsTitles[index];
                return Padding(
                  padding: EdgeInsets.all(15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                     Detailscreen(
                            image: news['urlToImage'] ?? '',
                            source: news['source']['name'] ?? 'Unknown Source',
                            author: news['author'] ?? 'Unknown Author',
                            title: news['title'] ?? 'No Title',
                            description: news['description'] ?? 'No Description',
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      child: Column(
                        children: [
                          news['urlToImage'] != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    news['urlToImage'],
                                    width: 400,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    'https://picsum.photos/seed/picsum/200/300', // Placeholder image
                                    width: 400,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          ListTile(
                            title: Text(
                              news['title'],
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                            subtitle: Text(
                              news['description'] ?? 'No description available',
                              style: GoogleFonts.poppins(color: Colors.white38),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}


