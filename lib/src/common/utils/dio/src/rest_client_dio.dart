import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:test_template/src/common/utils/dio/dio_client.dart';
import 'package:test_template/src/common/utils/dio/src/excepions/rest_client_exceptions.dart';
import 'package:test_template/src/common/utils/shared_preferences_helper.dart';

final class RestClientDio extends RestClientBase {
  RestClientDio({
    required super.baseURL,
    required super.logger,
    required final SharedPreferencesHelper sharedPreferHelper,
    final Dio? dio,
  }) : _dio = dio ?? Dio(),
       _logger = logger,
       _sharedPreferHelper = sharedPreferHelper;

  final Logger _logger;
  final SharedPreferencesHelper _sharedPreferHelper;
  final Dio _dio;

  @override
  Future<Map<String, dynamic>?> send({
    required String path,
    required DioMethod method,
    Map<String, dynamic>? data,
    FormData? formData,
    Map<String, String>? headers,
    Map<String, String?>? queryParams,
    bool log = false,
  }) async {
    final uri = buildUri(path: path, queryParams: queryParams);
    try {
      // remove List<int> if you change response type
      final request = await _dio.requestUri<List<int>>(
        uri,
        data: formData ?? data,
        options: Options(
          method: method.name.toUpperCase(),
          headers: headers ?? await this.headers,
          responseType: ResponseType.bytes, // remove here if you change response type
        ),
      );

      return decodeResponse(
        BytesResponseBody(body: request.data),
        statusCode: request.statusCode,
        log: log,
      );
    } on RestClientException {
      rethrow;
    } on DioException catch (error, stackTrace) {
      _logger.log(Level.error, error);
      _logger.log(Level.error, uri);
      if (error.response?.statusCode == HttpStatus.unauthorized) {
        throw UnAuthenticatedException(dioException: error, statusCode: HttpStatus.unauthorized);
      }

      final serverError = await decodeResponse(BytesResponseBody(body: error.response?.data));

      Error.throwWithStackTrace(
        DioExceptionHandler(dioException: error, serverError: "$serverError"),
        stackTrace,
      );
    }
  }

  Future<Map<String, String>> get headers async {
    return <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_sharedPreferHelper.getStringByKey(key: 'token')}',
    };
  }
}
