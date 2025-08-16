import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/home/Global.dart';
import 'package:news_app/view/home/entertainment.dart';

import 'package:news_app/view/home/trending.dart';
import 'package:news_app/view/home/busniess.dart';
import 'package:news_app/view/home/sports.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Trending(),
    Global(),
    Busniess(),
    Entertainment(),
    Sports(),
  ];

  final List<String> _tabs = [
    "TRENDING",
    "GLOBAL",
    "BUSINESS",
    "ENTERTAINMENT",
    "SPORTS",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
  body: Column(
  children: [
    // ✅ Scrollable top text-only tab bar
    Container(
      color: Colors.black,
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = index == _selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.grey,
                    decoration:
                        isSelected ? TextDecoration.underline : null,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    ),

    // ✅ Page content
    Expanded(
      child: _pages[_selectedIndex],
    ),
  ],
)

    );
  }
}
