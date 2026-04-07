import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/features/auth/presentation/views/login.dart';
import 'package:nexora/features/auth/presentation/views/register.dart';
import 'package:nexora/features/home/presentation/views/home_view.dart';
import 'package:nexora/features/main_layout/presentation/views/main_layout.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.login,
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
      ],
    )
  ],
);
