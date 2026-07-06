import 'package:dio/dio.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/core/services/secure_storage.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.getToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await SecureStorage.getRefreshToken();

      if (refreshToken != null) {
        try {
          final refreshDio = Dio();

          final response = await refreshDio.post(
            "${EndPoints.baseUrl}${EndPoints.refreshToken}",
            data: {"refreshToken": refreshToken},
          );

          final newAccessToken = response.data['accessToken'];
          await SecureStorage.saveToken(newAccessToken);

          err.requestOptions.headers["Authorization"] =
              "Bearer $newAccessToken";

          final retryResponse = await refreshDio.fetch(err.requestOptions);

          return handler.resolve(retryResponse);
        } catch (e) {
          await SecureStorage.clearAll();
        }
      } else {
        await SecureStorage.clearAll();
      }
    }

    super.onError(err, handler);
  }
}
