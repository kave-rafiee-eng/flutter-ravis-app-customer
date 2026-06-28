import 'dart:convert';

import 'package:flutter_application_1/chatbot/chatbot_history.dart';
import 'package:http/http.dart' as http;

const chatbotApiBaseUrl = 'http://109.125.149.108:8000';

class ChatbotResponse {
  final String answer;
  final String? model;

  const ChatbotResponse({required this.answer, this.model});
}

class ChatbotApi {
  static Future<ChatbotResponse> sendQuery({
    required String query,
    required List<LangChainHistoryMessage> history,
    bool executionReport = false,
    required String userId,
  }) async {
    print(chatbotApiBaseUrl);

    final response = await http.post(
      Uri.parse('$chatbotApiBaseUrl/agent'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userid': userId,
        'query': query,
        'history': history.map((e) => e.toJson()).toList(),
        'executionReport': false,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP error ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return ChatbotResponse(
      answer: data['answer'] as String? ?? '',
      model: data['model'] as String?,
    );
  }
}
