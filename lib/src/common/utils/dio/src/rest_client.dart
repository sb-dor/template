import 'package:dio/dio.dart';

abstract interface class RestClient {
  Future<Map<String, dynamic>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParameters,
    bool log,
  });

  Future<Map<String, dynamic>?> post(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log,
  });

  Future<Map<String, dynamic>?> put(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log,
  });

  Future<Map<String, dynamic>?> delete(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log,
  });
}
