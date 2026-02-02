import 'package:dio/dio.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? _buildDio();

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _buildDio() {
    return Dio(
      BaseOptions(
        baseUrl: 'https://rickandmortyapi.com/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );
  }
}
