/// A class that contains the verification response model.
class VerificationResponseModel {
  final bool ok;
  final Result? result;

  bool get isSuccess => ok;

  VerificationResponseModel({
    required this.ok,
    this.result,
  });

  factory VerificationResponseModel.fromJson(Map<String, dynamic> json) {
    return VerificationResponseModel(
      ok: json['ok'],
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }
}

/// A class that contains the result model.
class Result {
  final String? requestId;
  final String? phoneNumber;
  final num? requestCost;
  final num? remainingBalance;
  final DeliveryStatus? deliveryStatus;
  final VerificationStatus? verificationStatus;
  final String? payload;

  Result({
    this.requestId,
    this.phoneNumber,
    this.requestCost,
    this.remainingBalance,
    this.deliveryStatus,
    this.verificationStatus,
    this.payload,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      requestId: json['request_id'],
      phoneNumber: json['phone_number'],
      requestCost: json['request_cost'],
      remainingBalance: json['remaining_balance'],
      deliveryStatus: json['delivery_status'] != null
          ? DeliveryStatus.fromJson(json['delivery_status'])
          : null,
      verificationStatus: json['verification_status'] != null
          ? VerificationStatus.fromJson(json['verification_status'])
          : null,
      payload: json['payload'],
    );
  }
}

/// A class that contains the delivery status model.
class DeliveryStatus {
  final String status;
  final int updatedAt;

  DeliveryStatus({
    required this.status,
    required this.updatedAt,
  });

  factory DeliveryStatus.fromJson(Map<String, dynamic> json) {
    return DeliveryStatus(
      status: json['status'],
      updatedAt: json['updated_at'],
    );
  }
}

/// A class that contains the verification status model.
class VerificationStatus {
  final String status;
  final int updatedAt;
  final String codeEntered;

  bool get codeExpired => status == 'expired';

  bool get codeValid => status == 'code_valid';

  bool get codeInvalid => status == 'code_invalid';

  bool get codeMaxAttemptsExceeded => status == 'code_max_attempts_exceeded';

  VerificationStatus({
    required this.status,
    required this.updatedAt,
    required this.codeEntered,
  });

  factory VerificationStatus.fromJson(Map<String, dynamic> json) {
    return VerificationStatus(
      status: json['status'],
      updatedAt: json['updated_at'],
      codeEntered: json['code_entered'],
    );
  }
}
