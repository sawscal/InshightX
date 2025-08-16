// lib/speech_service.dart

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _speechEnabled = false;

  Future<void> initSpeech() async {
    _speechEnabled = await _speech.initialize();
  }

  bool get isListening => _speech.isListening;
  bool get isEnabled => _speechEnabled;

  void startListening(Function(String text, double confidence) onResult) async {
    if (_speechEnabled && !_speech.isListening) {
      await _speech.listen(
        onResult: (SpeechRecognitionResult result) {
          onResult(result.recognizedWords, result.confidence);
        },
      );
    }
  }

  void stopListening() async {
    await _speech.stop();
  }
}