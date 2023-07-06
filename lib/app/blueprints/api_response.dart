import 'package:flutter/foundation.dart';

abstract class ApiResponse {
  @protected
  late ResponseStatus _responseStatus;

  ResponseStatus get responseStatus => _responseStatus;

  @protected
  ApiResponse.fromMap(Map<String, dynamic>? map) {
    _responseStatus = ResponseStatus(
      status: map!['status'],
      sessionExpired: map['sessionExpired'] ?? false,
      errorMsg: map['errorMsg'],
    );
  }

  @protected
  ApiResponse.withError(String? error) {
    _responseStatus = ResponseStatus(
      status: false,
      errorMsg: error,
    );
  }

  @protected
  Map<String, dynamic> toMap();
}

class ResponseStatus {
  final bool? status;
  final bool sessionExpired;
  final String? errorMsg;

  ResponseStatus({
    this.status,
    this.sessionExpired = false,
    this.errorMsg = 'Bilinmeyen Hata',
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ResponseStatus &&
        other.status == status &&
        other.sessionExpired == sessionExpired;
  }

  @override
  int get hashCode => status.hashCode ^ sessionExpired.hashCode;
}
