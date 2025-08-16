// send_message_helper.dart
import 'dart:typed_data';
import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

typedef UpdateMessages = void Function(List<ChatMessage> newMessages);
typedef GetPromptGuidance = String Function(String selectedPromptType);

void sendMessageHelper({
  required ChatMessage chatMessage,
  required List<ChatMessage> messages,
  required ChatUser geminiUser,
  required String selectedPromptType,
  required UpdateMessages updateMessages, // (List<ChatMessage>)
  required GetPromptGuidance getPromptGuidance, // (String) => String
  required Gemini gemini,
}) {
  updateMessages([chatMessage, ...messages]);

  try {
    String question = chatMessage.text;
    List<Uint8List>? images;
    if (chatMessage.medias?.isNotEmpty ?? false) {
      images = [
        File(chatMessage.medias!.first.url).readAsBytesSync(),
      ];
    }

    String fullPrompt = '''
Prompt Type: $selectedPromptType

Guidance: ${getPromptGuidance(selectedPromptType)}

User Query: $question
''';

    gemini.streamGenerateContent(
      fullPrompt,
      images: images,
    ).listen((event) {
      ChatMessage? lastMessage = messages.firstOrNull;

      String response = event.content?.parts?.fold<String>(
            "",
            (previous, current) {
              if (current is TextPart) {
                return "$previous${current.text}";
              }
              return previous;
            },
          ) ??
          "";

      if (lastMessage != null && lastMessage.user == geminiUser) {
        lastMessage = messages.removeAt(0);
        lastMessage.text += response;
        updateMessages([lastMessage, ...messages]);
      } else {
        ChatMessage message = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        updateMessages([message, ...messages]);
      }
    }, onError: (error) {
      print("Gemini error: $error");
    });
  } catch (e) {
    print(e);
  }
}
