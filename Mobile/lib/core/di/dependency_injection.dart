import 'package:get_it/get_it.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/token_interceptor.dart';
import 'package:nexora/core/services/stripe_service.dart';
import 'package:nexora/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nexora/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';
import 'package:nexora/features/auth/domain/usecases/login_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/register_use_case.dart';
import 'package:nexora/features/auth/presentation/manager/auth_cubit.dart';
import 'package:nexora/features/cart/data/repositories/api_cart_repo_impl.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/category/data/repositories/api_category_repo_impl.dart';
import 'package:nexora/features/category/domain/repositories/category_repo.dart';
import 'package:nexora/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:nexora/features/orders/data/repositories/order_repo_impl.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';
import 'package:nexora/features/orders/domain/services/payment_service.dart';
import 'package:nexora/features/orders/domain/usecases/place_order_use_case.dart';
import 'package:nexora/features/orders/presentation/manager/checkout/checkout_cubit.dart';
import 'package:nexora/features/orders/presentation/manager/order_history/order_history_cubit.dart';
import 'package:nexora/features/product/data/repositories/api_product_repo_impl.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';
import 'package:nexora/features/product/presentation/manager/product_cubit.dart';
import 'package:nexora/features/wishlist/data/repositories/api_wishlist_repo_impl.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<TokenInterceptor>(() => TokenInterceptor());

  getIt.registerLazySingleton<ApiService>(
    () => ApiService(tokenInterceptor: getIt<TokenInterceptor>()),
  );

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(getIt<AuthRemoteDataSource>()),
  );

  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(getIt<AuthRepo>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<LoginUseCase>(), getIt<RegisterUseCase>()),
  );

  getIt.registerLazySingleton<CategoryRepo>(
    () => ApiCategoryRepoImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<WishlistRepo>(
    () => ApiWishlistRepoImpl(getIt<ApiService>()),
  );

  getIt.registerFactory<WishlistCubit>(
    () => WishlistCubit(getIt<WishlistRepo>()),
  );

  getIt.registerLazySingleton<ProductRepo>(
    () => ApiProductRepoImpl(getIt<ApiService>()),
  );

  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(getIt<ProductRepo>()),
  );

  getIt.registerLazySingleton<CartRepo>(
    () => ApiCartRepoImpl(getIt<ApiService>()),
  );

  getIt.registerFactory<CartCubit>(
    () => CartCubit(getIt<CartRepo>()),
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

  getIt.registerFactory<CheckoutCubit>(
    () => CheckoutCubit(getIt<PlaceOrderUseCase>()),
  );

  getIt.registerFactory<OrderHistoryCubit>(
    () => OrderHistoryCubit(getIt<OrderRepo>()),
  );
}
