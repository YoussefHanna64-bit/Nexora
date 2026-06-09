import 'package:get_it/get_it.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/token_interceptor.dart';
import 'package:nexora/features/auth/data/repositories/api_auth_repo_impl.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';
import 'package:nexora/features/home/data/repositories/api_category_repo_impl.dart';
import 'package:nexora/features/home/domain/repositories/category_repo.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<TokenInterceptor>(() => TokenInterceptor());

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(tokenInterceptor: getIt<TokenInterceptor>()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => ApiAuthRepoImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CategoryRepo>(
    () => ApiCategoryRepoImpl(getIt<ApiService>()),
  );
}
