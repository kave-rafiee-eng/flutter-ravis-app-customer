import 'package:flutter_application_1/chatbot/message_type.dart';

class LangChainHistoryMessage {
  final String type;
  final String content;

  const LangChainHistoryMessage({required this.type, required this.content});

  Map<String, String> toJson() => {'type': type, 'content': content};
}

List<LangChainHistoryMessage> createHistory(List<MessageType> msgs) {
  return msgs
      .map(
        (msg) => LangChainHistoryMessage(
          type: msg.type.name,
          content: msg.data,
        ),
      )
      .toList();
}
