import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar(
      {super.key,
      required this.title,
      this.showBackButton = false,
      this.onBackPressed});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: Icon(AppIcons.arrowBack, color: onSurface, size: 20),
              onPressed: onBackPressed ?? () => context.pop(),
            )
          : null,
      title: Text(
        title,
        style: AppTextStyles.bold20White.copyWith(
          color: onSurface,
        ),
      ),
    );
  }
}
