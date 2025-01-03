import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_constants.dart';

/// A simple HTTP client to make requests to the Telegram API.
class HttpClient {
  // The token to authenticate with the Telegram API.
  final String token;

  // The base URL of the Telegram API.
  final String baseUrl;

  HttpClient({
    required this.token,
    this.baseUrl = ApiConstants.baseUrl,
  });

  /// Sends a POST request to the Telegram API.
  Future<Map<String, dynamic>> post(
    String method, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$method'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
