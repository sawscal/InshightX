import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/ProfileSettingsScreen.dart';
  // Import your profile screen

Widget buildDrawerHeader(BuildContext context) {
  return DrawerHeader(
    decoration: BoxDecoration(
      color: Colors.black,
    ),
    child: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(
              child: Text('No user data', style: TextStyle(color: Colors.white)));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
                );
              },
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.black,
                backgroundImage: userData['profileImageUrl'] != null
                    ? NetworkImage(userData['profileImageUrl'])
                    : const AssetImage('assets/images/Animation - 1730377043122.gif')
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              userData['username'] ?? 'Mango',
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
            ),
          ],
        );
      },
    ),
  );
}
