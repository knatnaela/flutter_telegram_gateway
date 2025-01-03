// test/telegram_gateway_api_test.dart
import 'package:flutter_telegram_gateway/src/api.dart';
import 'package:flutter_telegram_gateway/src/models/verification_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const String testToken = '<YOUR_TOKEN>';
  const String testPhoneNumber = '<PHONE_NUMBER>';
  // Optional code
  const String testCode = '1234';

  // group test
  group('TelegramGatewayApi', () {
    late TelegramGatewayApi telegramGatewayApi;

    setUp(() {
      telegramGatewayApi = TelegramGatewayApi(token: testToken);
    });

    test('sendVerificationMessage', () async {
      final VerificationResponseModel response =
          await telegramGatewayApi.sendVerificationMessage(
        phoneNumber: testPhoneNumber,
        code: testCode,
      );
      // remove + sign from phone number
      final String phoneNumber = testPhoneNumber.substring(1);
      expect(response.isSuccess, true);
      expect(response.result!.phoneNumber, phoneNumber);
    });

    test('sendVerificationMessage should send random code', () async {
      final VerificationResponseModel response =
          await telegramGatewayApi.sendVerificationMessage(
        phoneNumber: testPhoneNumber,
        codeLength: 6,
      );
      // remove + sign from phone number
      final String phoneNumber = testPhoneNumber.substring(1);
      expect(response.isSuccess, true);
      expect(response.result!.phoneNumber, phoneNumber);
    });

    test('checkSendAbility', () async {
      final VerificationResponseModel response =
          await telegramGatewayApi.checkSendAbility(
        phoneNumber: testPhoneNumber,
      );
      final String phoneNumber = testPhoneNumber.substring(1);

      expect(response.isSuccess, true);
      expect(response.result!.requestId, isNotNull);
      expect(response.result!.phoneNumber, phoneNumber);
    });

    test('should check verification status successfully', () async {
      final response = await telegramGatewayApi.sendVerificationMessage(
          phoneNumber: testPhoneNumber, code: testCode);
      final requestId = response.result!.requestId;
      const code = testCode;

      // Call checkVerificationStatus and get a VerificationResponse
      final verificationStatus =
          await telegramGatewayApi.checkVerificationStatus(
        requestId: requestId!,
        code: code,
      );

      // Verify if the status is 'code valid'
      expect(verificationStatus.result?.verificationStatus?.codeValid, true);
    });

    test('should fail with incorrect requestId', () async {
      await telegramGatewayApi.sendVerificationMessage(
          phoneNumber: testPhoneNumber, code: testCode);
      // wrong requestId
      const requestId = "123456789";
      const code = testCode;

      // Call checkVerificationStatus with an incorrect requestId
      final verificationResponse = await telegramGatewayApi
          .checkVerificationStatus(requestId: requestId, code: code);
      expect(verificationResponse.isSuccess, false);
    });

    // should fail with incorrect code
    test('should fail with incorrect code', () async {
      final response = await telegramGatewayApi.sendVerificationMessage(
          phoneNumber: testPhoneNumber, code: testCode);
      final requestId = response.result!.requestId;
      // wrong code
      const code = "123456";

      // Call checkVerificationStatus with an incorrect code
      final verificationResponse = await telegramGatewayApi
          .checkVerificationStatus(requestId: requestId!, code: code);
      expect(verificationResponse.isSuccess, true);
      expect(verificationResponse.result?.verificationStatus?.codeValid, false);
      expect(
          verificationResponse.result?.verificationStatus?.codeInvalid, true);
    });
  });
}
