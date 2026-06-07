import 'package:dio/dio.dart';
import 'package:nexora/core/services/secure_storage.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      print("Unauthorized");
    }

    super.onError(err, handler);
  }
}
