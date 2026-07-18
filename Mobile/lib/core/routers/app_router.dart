import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/di/dependency_injection.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/presentation/views/add_edit_address_view.dart';
import 'package:nexora/features/address/presentation/views/shipping_addresses_view.dart';
import 'package:nexora/features/auth/presentation/manager/forgot_password/forgot_password_cubit.dart';
import 'package:nexora/features/auth/presentation/views/forgot_password_view.dart';
import 'package:nexora/features/auth/presentation/views/login.dart';
import 'package:nexora/features/auth/presentation/views/register.dart';
import 'package:nexora/features/cart/presentation/views/cart_view.dart';
import 'package:nexora/features/home/presentation/views/home_view.dart';
import 'package:nexora/features/main_layout/presentation/views/main_layout.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/presentation/manager/checkout/checkout_cubit.dart';
import 'package:nexora/features/orders/presentation/manager/order_history/order_history_cubit.dart';
import 'package:nexora/features/orders/presentation/views/checkout_view.dart';
import 'package:nexora/features/orders/presentation/views/my_orders_view.dart';
import 'package:nexora/features/orders/presentation/views/order_details_view.dart';
import 'package:nexora/features/orders/presentation/views/order_success_view.dart';
import 'package:nexora/features/product/presentation/manager/product/product_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product_details/product_details_cubit.dart';
import 'package:nexora/features/product/presentation/views/product_details_view.dart';
import 'package:nexora/features/profile/presentation/views/change_password_view.dart';
import 'package:nexora/features/profile/presentation/views/edit_profile_view.dart';
import 'package:nexora/features/profile/presentation/views/profile_view.dart';
import 'package:nexora/features/reviews/presentation/manager/review_cubit.dart';
import 'package:nexora/features/search/presentation/views/search_view.dart';
import 'package:nexora/features/settings/presentation/views/settings_view.dart';
import 'package:nexora/features/wishlist/presentation/views/wishlist_view.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.home,
  redirect: (context, state) async {
    final String? token = await SecureStorage.getToken();
    final bool isLoggedIn = token != null;

    final bool isGoingToAuth = state.matchedLocation == Routes.login ||
        state.matchedLocation == Routes.register ||
        state.matchedLocation == Routes.forgotPassword;

    if (!isLoggedIn && !isGoingToAuth) {
      return Routes.login;
    }

    if (isLoggedIn && isGoingToAuth) {
      return Routes.home;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: Routes.login,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: Routes.register,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Register(),
    ),
    GoRoute(
      path: Routes.forgotPassword,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<ForgotPasswordCubit>(),
          child: const ForgotPasswordView(),
        );
      },
    ),
    GoRoute(
      path: Routes.search,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final String? query = state.extra as String?;
        return BlocProvider(
          create: (context) => getIt<ProductCubit>(),
          child: SearchView(initialSearchQuery: query),
        );
      },
    ),
    GoRoute(
      path: Routes.productDetails,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final productId = state.extra as String;
        return BlocProvider(
          create: (context) => getIt<ProductDetailsCubit>(),
          child: ProductDetailsView(productId: productId),
        );
      },
    ),
    GoRoute(
      path: Routes.checkout,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<CheckoutCubit>(),
          child: const CheckoutView(),
        );
      },
    ),
    GoRoute(
      path: Routes.orderSuccess,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final order = state.extra as Order?;
        return OrderSuccessView(order: order);
      },
    ),
    GoRoute(
      path: Routes.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: Routes.myOrders,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<OrderHistoryCubit>()..fetchOrders(),
          child: const MyOrdersView(),
        );
      },
    ),
    GoRoute(
      path: Routes.orderDetails,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final order = state.extra as Order;

        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: getIt<OrderHistoryCubit>()),
            BlocProvider(create: (context) => getIt<ReviewCubit>()),
          ],
          child: OrderDetailsView(order: order),
        );
      },
    ),
    GoRoute(
      path: Routes.shippingAddresses,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return ShippingAddressesView();
      },
    ),
    GoRoute(
      path: Routes.addEditAddress,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final address = state.extra as ShippingAddress?;

        return AddEditAddressView(address: address);
      },
    ),
    GoRoute(
      path: Routes.editProfile,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return const EditProfileView();
      },
    ),
    GoRoute(
      path: Routes.changePassword,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        return const ChangePasswordView();
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: Routes.home,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            return BlocProvider<ProductCubit>(
              create: (context) => getIt<ProductCubit>()
                ..fetchProducts(queryParameters: {
                  'sort': '-sold',
                  'limit': 6,
                }),
              child: const HomeView(),
            );
          },
        ),
        GoRoute(
          path: Routes.cart,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const CartView(),
        ),
        GoRoute(
          path: Routes.wishlist,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const WishlistView(),
        ),
        GoRoute(
          path: Routes.profile,
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const ProfileView(),
        ),
      ],
    )
  ],
);
