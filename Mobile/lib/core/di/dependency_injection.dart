import 'package:get_it/get_it.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/token_interceptor.dart';
import 'package:nexora/core/services/stripe_service.dart';
import 'package:nexora/features/auth/data/repositories/api_auth_repo_impl.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';
import 'package:nexora/features/cart/data/repositories/api_cart_repo_impl.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';
import 'package:nexora/features/category/data/repositories/api_category_repo_impl.dart';
import 'package:nexora/features/category/domain/repositories/category_repo.dart';
import 'package:nexora/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:nexora/features/orders/data/repositories/order_repo_impl.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';
import 'package:nexora/features/orders/domain/services/payment_service.dart';
import 'package:nexora/features/orders/domain/usecases/place_order_use_case.dart';
import 'package:nexora/features/product/data/repositories/api_product_repo_impl.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';
import 'package:nexora/features/wishlist/data/repositories/api_wishlist_repo_impl.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';

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

  getIt.registerLazySingleton<WishlistRepo>(
    () => ApiWishlistRepoImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ProductRepo>(
    () => ApiProductRepoImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CartRepo>(
    () => ApiCartRepoImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<PaymentService>(
    () => StripeService(),
  );

  getIt.registerLazySingleton<OrderRemoteDataSource>(
    () => OrderRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<OrderRepo>(
    () => OrderRepoImpl(getIt<OrderRemoteDataSource>()),
  );

  getIt.registerLazySingleton<PlaceOrderUseCase>(
    () => PlaceOrderUseCase(getIt<OrderRepo>(), getIt<PaymentService>()),
  );
}
