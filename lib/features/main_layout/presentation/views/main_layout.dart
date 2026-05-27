import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  int selectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(Routes.home)) return 0;
    if (location.startsWith(Routes.cart)) return 1;
    if (location.startsWith(Routes.wishlist)) return 2;
    return 0;
  }

  void onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(Routes.home);
        break;
      case 1:
        context.go(Routes.cart);
        break;
      case 2:
        context.go(Routes.wishlist);
        break;
      case 3:
        // context.go(profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex(context),
        onTap: (index) => onItemTapped(index, context),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).dividerColor,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(AppIcons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(AppIcons.cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(AppIcons.favorites), label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: Icon(AppIcons.profile), label: 'Profile'),
        ],
      ),
    );
  }
}
