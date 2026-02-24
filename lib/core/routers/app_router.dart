import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/features/auth/presentation/views/login.dart';
import 'package:nexora/features/auth/presentation/views/register.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.login,
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) => const Login(),
    ),
    GoRoute(
      path: Routes.register,
      builder: (context, state) => const Register(),
    )
  ],
);
