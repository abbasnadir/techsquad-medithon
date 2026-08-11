import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: 'http://localhost:5000/api', // Adjust for deployment/production
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth tokens here if needed
        return handler.next(options);
      },
    ));
  }

  Dio get client => _dio;
}
