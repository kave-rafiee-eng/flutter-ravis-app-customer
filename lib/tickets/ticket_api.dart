import 'dart:convert';

import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:flutter_application_1/tickets/models/tecketModel.dart';
import 'package:http/http.dart' as http;

class TicketApiException implements Exception {
  final String message;

  const TicketApiException(this.message);

  @override
  String toString() => message;
}

class TicketApi {
  static const _timeout = Duration(seconds: 20);

  static Future<int> numOfUserUnreadedTickets(String userId) async {
    final response = await http
        .get(
          Uri.parse(
            '$serverBaseUrl/user/${Uri.encodeComponent(userId)}/tickets/num_unreaded',
          ),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'];
    }

    throw TicketApiException(extractErrorMessage(response));
  }

  static Future<TicketModel> readTicket(String ticketID) async {
    final response = await http
        .get(
          Uri.parse(
            '$serverBaseUrl/user/tickets/${Uri.encodeComponent(ticketID)}',
          ),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return TicketModel.fromJson(data as Map<String, dynamic>);
    }

    throw TicketApiException(extractErrorMessage(response));
  }

  static Future<List<TicketModel>> readTicketsByUserId(String userId) async {
    final response = await http
        .get(
          Uri.parse(
            '$serverBaseUrl/user/${Uri.encodeComponent(userId)}/tickets',
          ),
        )
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return _decodeTickets(response);
    }

    throw TicketApiException(extractErrorMessage(response));
  }

  static List<TicketModel> _decodeTickets(http.Response response) {
    final data = jsonDecode(response.body);

    if (data is List) {
      return data
          .map((item) => TicketModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    if (data is Map<String, dynamic>) {
      final tickets = data['tickets'] ?? data['data'];
      if (tickets is List) {
        return tickets
            .map((item) => TicketModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    }

    throw const TicketApiException('پاسخ سرور نامعتبر است');
  }

  static String extractErrorMessage(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
    } catch (_) {}

    return 'خطای HTTP ${response.statusCode}';
  }
}
