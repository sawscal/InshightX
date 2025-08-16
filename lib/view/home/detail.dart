import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/widgets/AICompanionSheet.dart';
import 'package:news_app/widgets/WatchNewsScreen.dart';

class Detailscreen extends StatefulWidget {
  final String image, source, author, title, description;

  const Detailscreen({
    super.key,
    required this.image,
    required this.source,
    required this.author,
    required this.title,
    required this.description,
  });

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  late FlutterTts flutterTts;
  
  bool  _isPressed = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
  }

  Future<void> speakText(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
    IconButton(
    icon: const Icon(Icons.bookmark_add, color: Colors.white),
  onPressed: saveNews,
    ),
    
//      Container(
//   decoration: BoxDecoration(
//     color: _isPressed ? Colors.grey.shade900 : Colors.black,
//     shape: BoxShape.circle,
//   ),
//   child: IconButton(
//     iconSize: 25,
//     icon: const Icon(
//       Icons.volume_down_alt,
//       color: Colors.white,
//     ),
//     onPressed: () async {
//       setState(() {
//         _isPressed = true;
//       });

//       final combinedText = "${widget.title}. ${widget.description}";
//       await speakText(combinedText);

//       // Optional short delay or wait till speech ends
//       await Future.delayed(const Duration(milliseconds: 300));

//       if (mounted) {
//         setState(() {
//            _isPressed = false;
//         });
//       }
//     },
//   ),
// ),
IconButton(
  iconSize: 25,
  icon: const Icon(
    Icons.smart_toy,
    color: Colors.white,
  ),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (_) => AICompanionSheet(
        articleText: "${widget.title}. ${widget.description}",
      ),
    );
  },
),


     ],
      ),
  


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Container
            Container(
              height: height * 0.6,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: height * 0.02),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: CachedNetworkImage(
                  imageUrl: widget.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: SpinKitCircle(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, color: Colors.white),
                ),
              ),
            ),
           
           Padding(
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      // Read Mode (default)
      Column(
        children: [
          Icon(Icons.article, color: Colors.white),
          Text("Read", style: TextStyle(color: Colors.white70)),
        ],
      ),
      // Listen Mode
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WatchNewsScreen(
          articleText: "${widget.title}. ${widget.description}",
        ),
      ),
    );
  },
  child: Column(
    children: const [
      Icon(Icons.movie, color: Colors.white),
      Text("Watch", style: TextStyle(color: Colors.white70)),
    ],
  ),
),

    ],
  ),
),




            // Text Content
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: height * 0.02),

                  // Source and author row
                  Row(
                    children: [
                      Text(
                        widget.source,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'by ${widget.author}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white54,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      // IconButton(
                      //   iconSize: 25,
                      //   icon: const Icon(
                      //     Icons.volume_down_alt,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     final combinedText =
                      //         "${widget.title}. ${widget.description}";
                      //     speakText(combinedText);
                      //   },
                      // ),
                    ],
                  ),
                  SizedBox(height: height * 0.03),

                  // Description
                  Text(
                    widget.description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveNews() async {
  final box = Hive.box<NewsModel>('savedNews');
  final news = NewsModel(
    image: widget.image,
    source: widget.source,
    author: widget.author,
    title: widget.title,
    description: widget.description,
  );

  final exists = box.values.any((item) => item.title == news.title);
  if (!exists) {
    await box.add(news);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("News saved!")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Already saved.")),
    );
  }
}

}


