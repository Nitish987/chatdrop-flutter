import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// REST API Client for communicating with server
class ApiClient {
  static final _dio = Dio();
  static final instance = ApiClient._();

  ApiClient._() {
    _dio.options.baseUrl = dotenv.env['API_URL']!;
    _dio.options.headers['cak'] = dotenv.env['API_KEY']!;
  }

  // attach headers
  void attachHeaders(Map<String, String> headers) {
    headers.forEach((key, value) => _dio.options.headers[key] = value);
  }

  // detach headers
  void detachHeaders(List<String> headers) {
    for (var key in headers) {
      _dio.options.headers.remove(key);
    }
  }

  // Get Request
  Future<Response<Map<String, dynamic>>> get({required String path, Map<String, dynamic>? queryParams}) =>
      _dio.get(path, queryParameters: queryParams);

  // Post Request
  Future<Response<Map<String, dynamic>>> post(
          {required String path, Map<String, dynamic>? data, Map<String, dynamic>? queryParams}) =>
      _dio.post(path, data: data, queryParameters: queryParams);

  // Patch Request
  Future<Response<Map<String, dynamic>>> patch(
          {required String path, required Map<String, dynamic> data, Map<String, dynamic>? queryParams}) =>
      _dio.patch(path, data: data, queryParameters: queryParams);

  // Put Request
  Future<Response<Map<String, dynamic>>> put(
          {required String path, required Map<String, dynamic> data, Map<String, dynamic>? queryParams}) =>
      _dio.put(path, data: data, queryParameters: queryParams);

  // Delete Request
  Future<Response<Map<String, dynamic>>> delete({required String path, Map<String, dynamic>? queryParams}) =>
      _dio.delete(path, queryParameters: queryParams);

  // MultiPart Post Request Request
  Future<Response<Map<String, dynamic>>> multiPartPost(
          {required String path, required Map<String, dynamic> data, Map<String, dynamic>? queryParams}) =>
      _dio.post(path, data: FormData.fromMap(data), queryParameters: queryParams);

  // MultiPart Post Request Request
  Future<Response<Map<String, dynamic>>> multiPartPut(
      {required String path, required Map<String, dynamic> data, Map<String, dynamic>? queryParams}) =>
      _dio.put(path, data: FormData.fromMap(data), queryParameters: queryParams);
}
