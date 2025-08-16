

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:news_app/services/InterestProfileService.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/view/InterestSelectorScreen.dart';
import 'package:news_app/view/foryourfeed.dart';
import 'package:news_app/view/chat_bot_screen.dart';
import 'package:news_app/view/home/home_nav.dart';
import 'package:news_app/view/saved_news_screen.dart';
import 'package:news_app/view/searchscreen.dart';
import 'package:news_app/widgets/drawerhead.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  final pages = [
    const HomeNav(),
    const ChatbotScreen(),
    const SavedNewsScreen(),
  ];

  int _selectedIndex = 0;
  
 final List<String> _titles = [
  'Home',
  'NewsBot',
  'Saved News',
];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
appBar: AppBar(
  iconTheme: const IconThemeData(color: Colors.white),
  backgroundColor: Colors.black,
  title: Text(
    _titles[_selectedIndex], // 👈 Dynamic title here
    style: GoogleFonts.poppins(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.search, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      },
    ),
  ],
),

      bottomNavigationBar: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal, // Allows horizontal scrolling for the GNav
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Container(
            color: Colors.black,
            height: 75,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: GNav(
                backgroundColor: Colors.black,
                color: Colors.white,
                activeColor: Colors.white,
                haptic: true,
                textStyle: GoogleFonts.poppins(color: Colors.white),
                tabBackgroundColor: Colors.transparent,
                gap: 10,
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
             tabs: [
             GButton(
             icon: Icons.home,
             text: "HOME",
             ),
             GButton(
             icon: Icons.circle, // Use a dummy icon
             iconColor: Colors.transparent,
             text: "NEWSBOT",
             leading: Image.asset(
             'assets/images/chat-ai.png',
             color: Colors.white,
              width: 24,
              height: 24,
              ),
             ),
             GButton(
             icon: Icons.save,
             text: "SAVE",
             ),
            ],
              ),
            ),
          ),
        ),
      ),



drawer: Drawer(
  backgroundColor: Colors.white,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(30),
      bottomRight: Radius.circular(30),
    ),
  ),
  child: ListView(
    children: [
      buildDrawerHeader(context),
      ListTile(
        title: Text('Profile', style: GoogleFonts.poppins(color: Colors.black)),
        leading: const Icon(Icons.person, color: Colors.black),
      ),
      ListTile(
        title: Text('Community', style: GoogleFonts.poppins(color: Colors.black)),
        leading: const Icon(Icons.group_add, color: Colors.black),
      ),
      const SizedBox(height: 12),

      /// ✅ FIXED: Wrap DynamicInterestSection inside a FutureBuilder
      FutureBuilder<User?>(
        future: FirebaseAuth.instance.authStateChanges().first,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const ListTile(
              title: Text('Not logged in', style: TextStyle(color: Colors.red)),
            );
          }

          final user = snapshot.data!;
          final userId = user.uid;
          final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';

          return DynamicInterestSection(
            userId: userId,
            openAiApiKey: apiKey,
            interestService: InterestProfileService(
              firestore: FirebaseFirestore.instance,
              userId: userId,
              openAiApiKey: apiKey,
            ),
            newsService: NewsService(),
          );
        },
      ),

      ListTile(
        title: Text('Settings', style: GoogleFonts.poppins(color: Colors.black)),
        leading: const Icon(Icons.settings, color: Colors.black),
      ),
    ],
  ),
),


      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
    );
  }
}
