import 'dart:convert';

import 'package:flutter_application_1/login/user_profile.dart';
import 'package:flutter_application_1/serverAndStorage/serverConnection.dart';
import 'package:http/http.dart' as http;

class LoginApiException implements Exception {
  final String message;

  const LoginApiException(this.message);

  @override
  String toString() => message;
}

class LoginApi {
  static const _timeout = Duration(seconds: 20);

  static Future<UserProfile> readProfileById(String id) async {
    final response = await http
        .get(Uri.parse('$serverBaseUrl/user/$id'))
        .timeout(_timeout);

    if (response.statusCode == 200) {
      return UserProfile.fromJson(_decodeUser(response));
    }

    throw LoginApiException(extractErrorMessage(response));
  }

  static Future<void> verifyCode({
    required String phone,
    required int code,
  }) async {
    final response = await http
        .post(
          Uri.parse('$serverBaseUrl/verification/verify'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phone': phone, 'code': code}),
        )
        .timeout(_timeout);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw LoginApiException(extractErrorMessage(response));
    }
  }

  static Future<Map<String, dynamic>> findOrCreateUser(String phone) async {
    final existingResponse = await http
        .get(
          Uri.parse(
            '$serverBaseUrl/user/by-phone/${Uri.encodeComponent(phone)}',
          ),
        )
        .timeout(_timeout);

    if (existingResponse.statusCode == 200) {
      return _decodeUser(existingResponse);
    }

    if (existingResponse.statusCode != 404) {
      throw LoginApiException(extractErrorMessage(existingResponse));
    }

    final createResponse = await http
        .post(
          Uri.parse('$serverBaseUrl/user'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phone': phone, 'name': phone}),
        )
        .timeout(_timeout);

    if (createResponse.statusCode != 200 && createResponse.statusCode != 201) {
      throw LoginApiException(extractErrorMessage(createResponse));
    }

    return _decodeUser(createResponse);
  }

  static Map<String, dynamic> _decodeUser(http.Response response) {
    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) {
      throw const LoginApiException('پاسخ سرور نامعتبر است');
    }
    return data;
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
