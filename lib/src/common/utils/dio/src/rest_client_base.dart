import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/common/utils/dio/src/excepions/rest_client_exceptions.dart';
import 'package:test_template/src/common/utils/dio/src/response_body/response_body.dart' as rb;

enum DioMethod { get, post, put, delete }

abstract base class RestClientBase implements RestClient {
  //
  RestClientBase({required String baseURL, required final Logger logger})
    : _baseURL = Uri.parse(baseURL),
      _logger = logger;

  final Uri _baseURL;
  final Logger _logger;
  final _jsonUTF8 = json.fuse(utf8);

  Future<Map<String, dynamic>?> send({
    required String path,
    required DioMethod method,
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log,
  });

  @override
  Future<Map<String, dynamic>?> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String?>? queryParameters,
    bool log = false,
  }) => send(
    path: path,
    method: DioMethod.get,
    headers: headers,
    queryParams: queryParameters,
    log: log,
  );

  @override
  Future<Map<String, dynamic>?> post(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log = false,
  }) => send(
    path: path,
    method: DioMethod.post,
    data: data,
    formData: formData,
    headers: headers,
    queryParams: queryParams,
    log: log,
  );

  @override
  Future<Map<String, dynamic>?> put(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log = false,
  }) => send(
    path: path,
    method: DioMethod.put,
    data: data,
    formData: formData,
    headers: headers,
    queryParams: queryParams,
    log: log,
  );

  @override
  Future<Map<String, dynamic>?> delete(
    String path, {
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log = false,
  }) => send(
    path: path,
    method: DioMethod.delete,
    data: data,
    formData: formData,
    headers: headers,
    queryParams: queryParams,
    log: log,
  );

  Uri buildUri({required String path, Map<String, String?>? queryParams}) {
    final String finalPath = Uri.parse("${_baseURL.path}$path").normalizePath().toString();

    final Map<String, Object?> params = Map.of(_baseURL.queryParameters);

    if (queryParams != null) {
      params.addAll(queryParams);
      params.removeWhere((key, value) => value == null);
    }

    final finalURL = _baseURL.replace(
      path: finalPath,
      queryParameters: params.isEmpty ? null : params,
    );

    // _logger.log(Level.debug, "$finalURL");

    return finalURL;
  }

  Future<Map<String, Object?>?> decodeResponse(
    final rb.ResponseBody<Object?>? data, {
    final int? statusCode,
    bool log = false,
  }) async {
    try {
      final decodedResponse = switch (data) {
        rb.StringResponseBody(body: final String data) => await _decodeString(data),
        rb.BytesResponseBody(body: final List<int> data) => await _decodeBytes(data),
        rb.MapResponseBody(body: final Map<String, dynamic> data) => data,
        _ => <String, dynamic>{},
      };

      if (decodedResponse case {"data": final Map<String, dynamic> data}) {
        return data;
      }

      if (decodedResponse case {"error": final Map<String, dynamic> error}) {
        throw StructuredBackendException(error: error, statusCode: statusCode);
      }

      if (decodedResponse is List) {
        return {"list": data};
      }

      if (log) {
        _logger.log(Level.debug, decodedResponse);
      }

      return decodedResponse;
    } on RestClientException {
      rethrow;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        ClientException(
          message: "Error occurred during decoding",
          statusCode: statusCode,
          cause: error,
        ),
        stackTrace,
      );
    }
  }

  Future<Map<String, dynamic>?> _decodeString(String data) async {
    if (data.isEmpty) return null;

    if (data.length > 1000) {
      return (await compute(jsonDecode, data)) as Map<String, dynamic>?;
    }

    return jsonDecode(data) as Map<String, dynamic>?;
  }

  Future<Map<String, dynamic>?> _decodeBytes(List<int> data) async {
    if (data.isEmpty) return null;

    if (data.length > 1000) {
      return (await compute(_jsonUTF8.decode, data)) as Map<String, dynamic>?;
    }

    return _jsonUTF8.decode(data) as Map<String, dynamic>?;
  }
}
