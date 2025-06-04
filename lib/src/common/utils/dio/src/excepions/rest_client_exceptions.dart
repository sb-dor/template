import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class RestClientException implements Exception {
  const RestClientException({required this.message, this.statusCode, this.cause});

  //
  final String message;
  final int? statusCode;
  final Object? cause;
}

final class StructuredBackendException extends RestClientException {
  const StructuredBackendException({required this.error, super.statusCode, super.cause})
    : super(message: 'Backend returned structured error');

  final Map<String, dynamic> error;

  @override
  String toString() =>
      'StructuredBackendException('
      'message: $message '
      'cause: $cause, '
      'statusCode: $statusCode, '
      ')';
}

// other exceptions that may happen in client side
final class ClientException extends RestClientException {
  const ClientException({required super.message, super.statusCode, super.cause});

  @override
  String toString() =>
      'ClientException('
      'message: $message, '
      'statusCode: $statusCode, '
      'cause: $cause'
      ')';
}

final class UnAuthenticatedException extends RestClientException {
  const UnAuthenticatedException({required this.dioException, super.statusCode, super.cause})
    : super(message: "User is unauthenticated");

  final DioException dioException;

  @override
  String toString() =>
      'StructuredBackendException('
      'message: $message | SERVER_ERROR: ${dioException.response?.data}'
      ' | ERROR: ${dioException.error}, '
      'cause: $cause, '
      'statusCode: $statusCode, '
      ')';
}

final class DioExceptionHandler {
  //
  const DioExceptionHandler({
    required final DioException dioException,
    required final String serverError,
  }) : _dioException = dioException,
       _serverError = serverError;

  final DioException _dioException;
  final String _serverError;

  @override
  String toString() {
    return "DioExceptionHandler: ${_dioException.message}: SERVER_ERROR: $_serverError"
        " | MESSAGE: ${_dioException.message} | ERROR: ${_dioException.error}"
        " | STATUS_MESSAGE: ${_dioException.response?.statusMessage}"
        " | STATUS_CODE: ${_dioException.response?.statusCode}"
        " | STACKTRACE: ${_dioException.stackTrace}"
        " | DIO_EXCEPTION_TYPE: ${_dioException.type}"
        " | REAL_URI: ${_dioException.response?.realUri}";
  }
}
