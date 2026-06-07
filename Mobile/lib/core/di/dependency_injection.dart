import 'package:get_it/get_it.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/token_interceptor.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<TokenInterceptor>(() => TokenInterceptor());

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(tokenInterceptor: getIt<TokenInterceptor>()),
  );
}
