// lib/src/api.dart
import 'package:flutter_telegram_gateway/src/models/verification_response_model.dart';
import 'package:flutter_telegram_gateway/src/utils/api_constants.dart';

import 'utils/http_client.dart';

/// A client to interact with the Telegram Gateway API.
class TelegramGatewayApi {
  // The HTTP client to make requests to the Telegram API.
  final HttpClient httpClient;

  TelegramGatewayApi({
    required String token,
  }) : httpClient = HttpClient(token: token);

  /// Sends a verification message to a phone number.
  Future<VerificationResponseModel> sendVerificationMessage({
    required String phoneNumber,
    String? requestId,
    String? senderUsername,
    String? code,
    int? codeLength,
    String? callbackUrl,
    String? payload,
    int? ttl,
  }) async {
    if (code == null && codeLength == null) {
      throw ArgumentError(
        'Either code or codeLength must be provided.',
      );
    }

    final body = {
      'phone_number': phoneNumber,
      if (requestId != null) 'request_id': requestId,
      if (senderUsername != null) 'sender_username': senderUsername,
      if (code != null) 'code': code,
      if (codeLength != null) 'code_length': codeLength,
      if (callbackUrl != null) 'callback_url': callbackUrl,
      if (payload != null) 'payload': payload,
      if (ttl != null) 'ttl': ttl,
    };
    try {
      final Map<String, dynamic> response = await httpClient.post(
        ApiConstants.sendVerificationMessage,
        body: body,
      );
      return VerificationResponseModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Checks if a phone number can receive a verification message.
  Future<VerificationResponseModel> checkSendAbility({
    required String phoneNumber,
  }) async {
    final body = {
      'phone_number': phoneNumber,
    };
    final Map<String, dynamic> response = await httpClient.post(
      ApiConstants.checkSendAbility,
      body: body,
    );

    return VerificationResponseModel.fromJson(response);
  }

  /// Check the status of a verification request.
  Future<VerificationResponseModel> checkVerificationStatus({
    required String requestId,
    required String code,
  }) async {
    final body = {
      'request_id': requestId,
      'code': code,
    };
    final Map<String, dynamic> response = await httpClient.post(
      ApiConstants.checkVerificationStatus,
      body: body,
    );

    return VerificationResponseModel.fromJson(response);
  }

  /// Retrieve the status of a previously sent verification request using request_id.
  Future<Map<String, dynamic>> getRequestStatus({
    required String requestId,
  }) async {
    final body = {
      'request_id': requestId,
    };
    return await httpClient.post('getRequestStatus', body: body);
  }
}
