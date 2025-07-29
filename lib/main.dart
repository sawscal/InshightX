// ignore_for_file: unused_element

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/funtions/new.dart';
import 'package:news_app/view/home.dart';
import 'package:news_app/view/splash_screen.dart';
import 'package:news_app/view/busniess.dart';
import 'package:news_app/view/entertainment.dart';
import 'package:news_app/view/home_nav.dart';
import 'package:news_app/view/sports.dart';
import 'package:news_app/view/trending.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
      ),
      home: const SplashScreen(),
    );
  }
}

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final pages = [
    const home(),
    const Trending(),
    const Sports(),
    const Entertainment(),
    const Busniess(),
  ];

  int _selectedIndex = 0;

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
        iconTheme: const IconThemeData(
      color: Colors.white, 
    ),
        backgroundColor: Colors.black,
        title: Text(
          'Headline',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'HOME',
                  ),
                  GButton(
                    icon: Icons.trending_up_rounded,
                    text: 'LIFESTYLE',
                  ),
                  GButton(
                    icon: Icons.business,
                    text: 'BUSINESS',
                  ),
                  GButton(
                    icon: Icons.music_note,
                    text: 'ENTERTAINMENT',
                  ),
                  GButton(
                    icon: Icons.sports_baseball_sharp,
                    text: 'SPORTS',
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
      topRight: Radius.circular(30), // Rounded top right corner
      bottomRight: Radius.circular(30), // Rounded bottom right corner
    ),
  ),
  child: ListView(
    children: [
      DrawerHeader(
  decoration: BoxDecoration(
    color: Colors.black, 
    // borderRadius: const BorderRadius.only(
    //   topRight: Radius.circular(30), // Matching the top right corner
    // ),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 40, // Size of the avatar
        backgroundColor: Colors.black, // Background color for the avatar
        backgroundImage: AssetImage('assets/images/Animation - 1730377043122.gif'), // Replace with your asset path
      ),
      SizedBox(height: 10), // Space between avatar and text
      Text(
        'Mango',
        style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
      ),
    ],
  ),
),

      ListTile(
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        leading: Icon(Icons.person, color: Colors.black),
      ),
      ListTile(
        title: Text(
          'Community',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        leading: Icon(Icons.group_add, color: Colors.black),
      ),
       ListTile(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        leading: Icon(Icons.settings, color: Colors.black),
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
