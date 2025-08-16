import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Tts extends StatefulWidget {
  const Tts({super.key});

  @override
  State<Tts> createState() => _TtsState();
}


class _TtsState extends State<Tts> {
  final FlutterTts _flutterTts = FlutterTts();
  Map<String, dynamic>? _currentVoice;

  @override
  void initState() {
    super.initState();
    initTTS();
  }

  Future<void> initTTS() async {
    try {
      List<dynamic> voices = await _flutterTts.getVoices;
      List<Map<String, dynamic>> filteredVoices = voices
          .map((voice) => Map<String, dynamic>.from(voice))
          .where((voice) => voice["name"].toString().contains("en"))
          .toList();

      if (filteredVoices.isNotEmpty) {
        setState(() {
          _currentVoice = filteredVoices.first;
        });
        setVoice(_currentVoice!);
      }
    } catch (e) {
      print("Error initializing TTS: $e");
    }
  }

  void setVoice(Map voice) {
    _flutterTts.setVoice({"name": voice["name"], "locate": voice["locate"]});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
