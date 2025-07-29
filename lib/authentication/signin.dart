import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app/main.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}
class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Image.asset('assets/images/world.png',
          width: 5,
          height: 5,
        //  fit: BoxFit.cover,
         ),
        title: Text(
          'InshightX',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Center(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        height: 100,
      ),
      Text(
        'Welcome back',
        style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 27,
            fontWeight: FontWeight.w500),
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        'Welcome back! Please enter your details.',
        style: GoogleFonts.poppins(
          color: Colors.grey[500],
          fontSize: 12,
        ),
      ),
      SizedBox(
        height: 20,
      ),
      ElevatedButton(
        onPressed: () {
          signInWithGoogle();
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          backgroundColor: Colors.white, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
            side: BorderSide(color: Colors.grey.shade500), // Border color
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/google.png',
              height: 24,
              width: 24,
            ),
            SizedBox(width: 8),
            Text(
              'Log in with Google',
              style: GoogleFonts.poppins(
                color: Colors.black, 
                fontSize: 16, 
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 20), 
      Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1, 
              color: Colors.grey.shade400,
              indent: 20, 
              endIndent: 10, 
            ),
          ),
          Text(
            'or',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 16, 
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey.shade400,
              indent: 10,
              endIndent: 20,
            ),
          ),
        ],
      ),
   SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), 
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: GoogleFonts.poppins(
              color: Colors.grey.shade400, 
            ),
            filled: true,
            fillColor: Colors.white, 
            ),
          ),
        ),
       SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20), 
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: GoogleFonts.poppins(
              color: Colors.grey.shade400, 
            ),
            filled: true,
            fillColor: Colors.white, 
            ),
          ),
        ),
   Row(
  mainAxisAlignment: MainAxisAlignment.end, 
  children: [
    ElevatedButton(
      onPressed: () {
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, 
        elevation: 0, 
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), 
          side: BorderSide(color: Colors.white), 
        ),
      ),
      child: Text(
        'Forgot password',
        style: GoogleFonts.poppins(
          color: Colors.black, 
          fontSize: 14,
          fontWeight: FontWeight.w500, // Font weight
        ),
      ),
    ),
  ],
),
 SizedBox(
          height: 70,
        ),
      Container(
  width: double.infinity, // Full width of the parent
  child: ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.black), // Button color
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0)), // Adjust vertical padding
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rounded corners
        ),
      ),
    ),
    onPressed: () {
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => NewsScreen()),
      );
    },
    child: Text(
      "Log In",
      style: TextStyle(
        color: Colors.white, 
        fontSize: 18,
        fontWeight: FontWeight.bold, 
      ),
    ),
  ),
)
    ],
  ),
),
 );
  }
  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print(userCredential.user?.displayName);
  }
}
