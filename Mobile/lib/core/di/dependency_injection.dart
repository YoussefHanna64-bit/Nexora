import 'package:get_it/get_it.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/token_interceptor.dart';
import 'package:nexora/core/services/stripe_service.dart';
import 'package:nexora/core/services/user_cache_service.dart';
import 'package:nexora/features/address/data/datasources/address_remote_data_source.dart';
import 'package:nexora/features/address/data/repositories/address_repo_impl.dart';
import 'package:nexora/features/address/domain/repositories/address_repo.dart';
import 'package:nexora/features/address/domain/usecases/get_addresses_use_case.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nexora/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';
import 'package:nexora/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/google_auth_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/login_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/register_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_cubit.dart';
import 'package:nexora/features/auth/presentation/manager/forgot_password/forgot_password_cubit.dart';
import 'package:nexora/features/banner/data/datasources/banner_remote_data_source.dart';
import 'package:nexora/features/banner/data/repositories/banner_repo_impl.dart';
import 'package:nexora/features/banner/domain/repositories/banner_repo.dart';
import 'package:nexora/features/banner/domain/usecases/get_active_banners_use_case.dart';
import 'package:nexora/features/banner/presentation/manager/banner_cubit.dart';
import 'package:nexora/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:nexora/features/cart/data/repositories/cart_repo_impl.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';
import 'package:nexora/features/cart/domain/usecases/add_product_to_cart_use_case.dart';
import 'package:nexora/features/cart/domain/usecases/get_user_cart_use_case.dart';
import 'package:nexora/features/cart/domain/usecases/remove_cart_item_use_case.dart';
import 'package:nexora/features/cart/domain/usecases/update_cart_item_quantity_use_case.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/category/data/datasources/category_remote_data_source.dart';
import 'package:nexora/features/category/data/repositories/category_repo_impl.dart';
import 'package:nexora/features/category/domain/repositories/category_repo.dart';
import 'package:nexora/features/category/domain/usecases/get_categories_use_case.dart';
import 'package:nexora/features/brands/data/datasources/brand_remote_data_source.dart';
import 'package:nexora/features/brands/data/repositories/brand_repo_impl.dart';
import 'package:nexora/features/brands/domain/repositories/brand_repo.dart';
import 'package:nexora/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:nexora/features/orders/data/repositories/order_repo_impl.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';
import 'package:nexora/features/orders/domain/services/payment_service.dart';
import 'package:nexora/features/orders/domain/usecases/cancel_order_use_case.dart';
import 'package:nexora/features/orders/domain/usecases/get_user_orders_use_case.dart';
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
import 'package:nexora/features/profile/domain/usecases/upload_profile_picture_use_case.dart';
import 'package:nexora/features/profile/presentation/manager/profile_cubit.dart';
import 'package:nexora/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:nexora/features/reviews/data/repositories/review_repo_impl.dart';
import 'package:nexora/features/reviews/domain/repositories/review_repo.dart';
import 'package:nexora/features/reviews/domain/usecases/add_review_use_case.dart';
import 'package:nexora/features/reviews/domain/usecases/delete_review_use_case.dart';
import 'package:nexora/features/reviews/domain/usecases/get_product_reviews_use_case.dart';
import 'package:nexora/features/reviews/domain/usecases/update_review_use_case.dart';
import 'package:nexora/features/reviews/presentation/manager/review_cubit.dart';
import 'package:nexora/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:nexora/features/wishlist/data/repositories/wishlist_repo_impl.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';
import 'package:nexora/features/wishlist/domain/usecases/get_user_wishlist_use_case.dart';
import 'package:nexora/features/wishlist/domain/usecases/toggle_wishlist_use_case.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<UserCacheService>(() => UserCacheService());

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

  getIt.registerLazySingleton<GoogleAuthUseCase>(
    () => GoogleAuthUseCase(getIt<AuthRepo>()),
  );

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      getIt<LoginUseCase>(),
      getIt<RegisterUseCase>(),
      getIt<GoogleAuthUseCase>(),
      getIt<UserCacheService>(),
    ),
  );

  getIt.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<VerifyOTPUseCase>(
    () => VerifyOTPUseCase(getIt<AuthRepo>()),
  );

  getIt.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(getIt<AuthRepo>()),
  );

  getIt.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
      verifyOTPUseCase: getIt<VerifyOTPUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
    ),
  );

  getIt.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<CategoryRepo>(
    () => CategoryRepoImpl(getIt<CategoryRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(getIt<CategoryRepo>()),
  );

  getIt.registerLazySingleton<BrandRemoteDataSource>(
    () => BrandRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<BrandRepo>(
    () => BrandRepoImpl(getIt<BrandRemoteDataSource>()),
  );

  getIt.registerLazySingleton<WishlistRemoteDataSource>(
    () => WishlistRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<WishlistRepo>(
    () => WishlistRepoImpl(getIt<WishlistRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetUserWishlistUseCase>(
    () => GetUserWishlistUseCase(getIt<WishlistRepo>()),
  );

  getIt.registerLazySingleton<ToggleWishlistUseCase>(
    () => ToggleWishlistUseCase(getIt<WishlistRepo>()),
  );

  getIt.registerFactory<WishlistCubit>(
    () => WishlistCubit(
        getIt<GetUserWishlistUseCase>(), getIt<ToggleWishlistUseCase>()),
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

  getIt.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ReviewRepo>(
    () => ReviewRepoImpl(getIt<ReviewRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetProductReviewsUseCase>(
    () => GetProductReviewsUseCase(getIt<ReviewRepo>()),
  );

  getIt.registerLazySingleton<AddReviewUseCase>(
    () => AddReviewUseCase(getIt<ReviewRepo>()),
  );

  getIt.registerLazySingleton<UpdateReviewUseCase>(
    () => UpdateReviewUseCase(getIt<ReviewRepo>()),
  );

  getIt.registerLazySingleton<DeleteReviewUseCase>(
    () => DeleteReviewUseCase(getIt<ReviewRepo>()),
  );

  getIt.registerFactory<ReviewCubit>(
    () => ReviewCubit(
      getIt<GetProductReviewsUseCase>(),
      getIt<AddReviewUseCase>(),
      getIt<UpdateReviewUseCase>(),
      getIt<DeleteReviewUseCase>(),
    ),
  );

  getIt.registerLazySingleton<BannerRemoteDataSource>(
    () => BannerRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<BannerRepo>(
    () => BannerRepoImpl(getIt<BannerRemoteDataSource>()),
  );

  getIt.registerLazySingleton<GetActiveBannersUseCase>(
    () => GetActiveBannersUseCase(getIt<BannerRepo>()),
  );

  getIt.registerFactory<BannerCubit>(
    () => BannerCubit(getIt<GetActiveBannersUseCase>()),
  );

  getIt.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(getIt<ApiService>()),
  );

  getIt.registerLazySingleton<GetUserCartUseCase>(
    () => GetUserCartUseCase(getIt<CartRepo>()),
  );

  getIt.registerLazySingleton<AddProductToCartUseCase>(
    () => AddProductToCartUseCase(getIt<CartRepo>()),
  );

  getIt.registerLazySingleton<UpdateCartItemQuantityUseCase>(
    () => UpdateCartItemQuantityUseCase(getIt<CartRepo>()),
  );

  getIt.registerLazySingleton<RemoveCartItemUseCase>(
    () => RemoveCartItemUseCase(getIt<CartRepo>()),
  );

  getIt.registerLazySingleton<CartRepo>(
    () => CartRepoImpl(getIt<CartRemoteDataSource>()),
  );

  getIt.registerFactory<CartCubit>(
    () => CartCubit(
        getIt<GetUserCartUseCase>(),
        getIt<AddProductToCartUseCase>(),
        getIt<UpdateCartItemQuantityUseCase>(),
        getIt<RemoveCartItemUseCase>()),
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

  getIt.registerLazySingleton<GetUserOrdersUseCase>(
    () => GetUserOrdersUseCase(getIt<OrderRepo>()),
  );

  getIt.registerLazySingleton<CancelOrderUseCase>(
    () => CancelOrderUseCase(getIt<OrderRepo>()),
  );

  getIt.registerFactory<OrderHistoryCubit>(
    () => OrderHistoryCubit(
        getIt<GetUserOrdersUseCase>(), getIt<CancelOrderUseCase>()),
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

  getIt.registerLazySingleton<UploadProfilePictureUseCase>(
    () => UploadProfilePictureUseCase(getIt<ProfileRepo>()),
  );

  getIt.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(getIt<ProfileRepo>()),
  );

  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(
      getIt<GetUserProfileUseCase>(),
      getIt<UpdateProfileUseCase>(),
      getIt<UpdatePasswordUseCase>(),
      getIt<UploadProfilePictureUseCase>(),
      getIt<DeleteAccountUseCase>(),
      getIt<UserCacheService>(),
    ),
  );
}
