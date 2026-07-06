import 'package:get_it/get_it.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/token_interceptor.dart';
import 'package:nexora/core/services/stripe_service.dart';
import 'package:nexora/features/address/data/datasources/address_remote_data_source.dart';
import 'package:nexora/features/address/data/repositories/address_repo_impl.dart';
import 'package:nexora/features/address/domain/repositories/address_repo.dart';
import 'package:nexora/features/address/domain/usecases/get_addresses_use_case.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
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
import 'package:nexora/features/product/data/datasources/product_remote_data_source.dart';
import 'package:nexora/features/product/data/repositories/product_repo_impl.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';
import 'package:nexora/features/product/domain/usecases/get_all_products_use_case.dart';
import 'package:nexora/features/product/domain/usecases/get_product_by_id_use_case.dart';
import 'package:nexora/features/product/presentation/manager/product/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product_details/product_details_cubit.dart';
import 'package:nexora/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nexora/features/profile/data/repositories/profile_repo_impl.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';
import 'package:nexora/features/address/domain/usecases/add_address_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/delete_account_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:nexora/features/address/domain/usecases/remove_address_use_case.dart';
import 'package:nexora/features/address/domain/usecases/update_address_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_password_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:nexora/features/profile/presentation/manager/profile_cubit.dart';
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

  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ProductRepo>(
    () => ProductRepoImpl(getIt<ProductRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetAllProductsUseCase>(
    () => GetAllProductsUseCase(getIt<ProductRepo>()),
  );

  getIt.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(getIt<ProductRepo>()),
  );

  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(getIt<GetAllProductsUseCase>()),
  );

  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(getIt<GetProductByIdUseCase>()),
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

  getIt.registerLazySingleton<AddressRemoteDataSource>(
    () => AddressRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<AddressRepo>(
    () => AddressRepoImpl(getIt<AddressRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetAddressesUseCase>(
    () => GetAddressesUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<AddAddressUseCase>(
    () => AddAddressUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<UpdateAddressUseCase>(
    () => UpdateAddressUseCase(getIt<AddressRepo>()),
  );

  getIt.registerLazySingleton<RemoveAddressUseCase>(
    () => RemoveAddressUseCase(getIt<AddressRepo>()),
  );

  getIt.registerFactory<AddressCubit>(
    () => AddressCubit(
      getIt<GetAddressesUseCase>(),
      getIt<AddAddressUseCase>(),
      getIt<UpdateAddressUseCase>(),
      getIt<RemoveAddressUseCase>(),
    ),
  );

  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ProfileRepo>(
    () => ProfileRepoImpl(getIt<ProfileRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetUserProfileUseCase>(
    () => GetUserProfileUseCase(getIt<ProfileRepo>()),
  );

  getIt.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(getIt<ProfileRepo>()),
  );

  getIt.registerLazySingleton<UpdatePasswordUseCase>(
    () => UpdatePasswordUseCase(getIt<ProfileRepo>()),
  );

  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(getIt<ProfileRepo>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt<GetUserProfileUseCase>(),
      getIt<UpdateProfileUseCase>(),
      getIt<UpdatePasswordUseCase>(),
      getIt<DeleteAccountUseCase>(),
    ),
  );
}
