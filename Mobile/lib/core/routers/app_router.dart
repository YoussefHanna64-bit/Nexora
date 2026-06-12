import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/auth/presentation/views/login.dart';
import 'package:nexora/features/auth/presentation/views/register.dart';
import 'package:nexora/features/cart/presentation/views/cart_view.dart';
import 'package:nexora/features/home/presentation/views/home_view.dart';
import 'package:nexora/features/main_layout/presentation/views/main_layout.dart';
import 'package:nexora/features/product_details/presentation/views/product_details_view.dart';
import 'package:nexora/features/profile/presentation/views/profile_view.dart';
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
        state.matchedLocation == Routes.register;

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
      path: Routes.search,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final String? query = state.extra as String?;
        return SearchView(initialSearchQuery: query);
      },
    ),
    GoRoute(
      path: Routes.productDetails,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductDetailsView(product: product);
      },
    ),
    GoRoute(
      path: Routes.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsView(),
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
          builder: (context, state) => const HomeView(),
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
