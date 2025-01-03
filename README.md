
# Telegram Gateway API Flutter Package

A Flutter package for easy interaction with the Telegram Gateway API. This package simplifies the process of sending verification messages, verifying the received code, and checking verification status.

## Features

- **Send Verification Message**: Send a verification code to a phone number.
- **Verify Code**: Verify the entered code against the generated request ID.
- **Check Verification Status**: Check if the entered code corresponds to the request ID.
- **Check Send Ability**: Check if it's possible to send a verification message and whether a fee applies.

## Prerequisites

Before using this package, you will need:

1. **Telegram Gateway API Account**: Make sure you have an active Telegram Gateway API account.
2. **API Token**: You will need your API token to authenticate requests. This token is required to interact with the Telegram Gateway API.

You can find the API token after registering on the [Telegram Gateway API platform](https://core.telegram.org/gateway/api).

## Before You Begin

Please take a look at the [Before You Start guide](https://core.telegram.org/gateway/verification-tutorial#before-you-start) to ensure that you understand the necessary setup and requirements for the Telegram Gateway API, including important information about the verification process.


## Installation

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  telegram_gateway_api: ^0.0.2  # Replace with the latest version
```

Then, run:

```bash
flutter pub get
```

## Usage

### Import the package

```dart
import 'package:telegram_gateway_api/telegram_gateway_api.dart';
```

### Send a Verification Message

Use `sendVerificationMessage` to initiate the verification process.

```dart
final phoneNumber = '1234567890'; // Replace with the user's phone number
final telegramApi = TelegramGatewayApi();

final verificationResponse = await telegramApi.sendVerificationMessage(phoneNumber);

if (verificationResponse.requestId != null) {
  print('Verification request initiated with request_id: ${verificationResponse.requestId}');
}
```

### Check Send Ability

Before sending a verification message, you can check if it's possible to send the verification message and if there will be any charges. If the method returns a valid `requestId`, you can use it for **free of charge**.

- The first call to `sendVerificationMessage` with `requestId` will not incur any charges.
- Repeated attempts with the same `requestId` will result in an error, but a new request without a `requestId` will incur applicable fees.

```dart
final sendAbilityResponse = await telegramApi.checkSendAbility(phoneNumber);

if (sendAbilityResponse.requestId != null) {
  final verificationResponse = await telegramApi.sendVerificationMessage(
    phoneNumber,
    requestId: sendAbilityResponse.requestId!,
  );
}
```

### Check Verification Status

After the user receives the verification code, you can check its validity by calling `checkVerificationStatus`.

```dart
final requestId = 'uniqueRequestId';  // Received from sendVerificationMessage
final code = '1234';  // Code entered by the user

final verificationStatus = await telegramApi.checkVerificationStatus(requestId, code);

if (verificationStatus.status == 'success') {
  print('Code verified successfully!');
}
```

## Important Notes

- **Used Verification Codes**: Telegram does not handle the verification of previously used codes. You should manage the verification of used codes within your own implementation. This means that once a verification code is used, you need to keep track of its status and prevent re-verification.


## License

```text
MIT License
```
