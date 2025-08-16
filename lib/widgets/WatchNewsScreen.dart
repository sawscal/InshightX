import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class WatchNewsScreen extends StatefulWidget {
  final String articleText;
  const WatchNewsScreen({super.key, required this.articleText});

  @override
  _WatchNewsScreenState createState() => _WatchNewsScreenState();
}

class _WatchNewsScreenState extends State<WatchNewsScreen> {
  final StoryController _storyController = StoryController();

  List<StoryItem> _buildStoryItems(String text) {
    final parts = text.split(".").take(5).toList(); // basic summary
    return parts.map((part) {
      return StoryItem.text(
        title: part.trim(),
        backgroundColor: Colors.black,
        textStyle: const TextStyle(
          fontSize: 22,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final storyItems = _buildStoryItems(widget.articleText);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            StoryView(
              storyItems: storyItems,
              controller: _storyController,
              onComplete: () {
                Navigator.pop(context); // exit when finished
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context); // swipe down to close
                }
              },
            ),
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
