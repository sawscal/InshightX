// ignore_for_file: unused_element

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/model/news_model.dart';
import 'package:news_app/utils/theme_provider.dart';
import 'package:news_app/view/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(NewsModelAdapter());
  await Hive.openBox<NewsModel>('savedNews');

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print("✅ Firebase initialized.");
  } catch (e) {
    print("❌ Firebase init error: $e");
  }

  // Load .env
  try {
    await dotenv.load(fileName: "assets/.env");
    print("✅ .env loaded successfully.");
  } catch (e) {
    print("❌ Failed to load .env: $e");
  }

  // Initialize Gemini
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  if (apiKey != null && apiKey.isNotEmpty) {
    try {
      Gemini.init(apiKey: apiKey);
      print("✅ Gemini initialized with API key.");
    } catch (e) {
      print("❌ Error initializing Gemini: $e");
    }
  } else {
    print("⚠️ GEMINI_API_KEY not found in .env file.");
  }

  // Set transparent status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
