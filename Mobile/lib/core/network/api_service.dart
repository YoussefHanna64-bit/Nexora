import 'package:dio/dio.dart';
import 'package:nexora/core/network/end_points.dart';

class ApiService {
  final Dio dio;

  ApiService({Interceptor? tokenInterceptor})
      : dio = Dio(
          BaseOptions(
            baseUrl: EndPoints.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
          ),
        ) {
    if (tokenInterceptor != null) {
      dio.interceptors.add(tokenInterceptor);
    }

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ));
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) async {
    return await dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> post(String url,
      {Map<String, dynamic>? headers,
      dynamic body,
      Map<String, dynamic>? queryParameters}) async {
    return await dio.post(
      url,
      queryParameters: queryParameters,
      data: body,
      options: Options(headers: headers),
    );
  }

  Future<Response> delete(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters}) async {
    return await dio.delete(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );
  }

  Future<Response> put(String url,
      {Map<String, dynamic>? headers,
      dynamic body,
      Map<String, dynamic>? queryParameters}) async {
    return await dio.put(
      url,
      queryParameters: queryParameters,
      data: body,
      options: Options(headers: headers),
    );
  }

  Future<Response> patch(String url,
      {Map<String, dynamic>? headers,
      dynamic body,
      Map<String, dynamic>? queryParameters}) async {
    return await dio.patch(
      url,
      queryParameters: queryParameters,
      data: body,
      options: Options(headers: headers),
    );
  }
}
