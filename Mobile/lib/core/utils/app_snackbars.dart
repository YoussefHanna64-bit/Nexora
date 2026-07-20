import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class AppSnackbars {
  static void showSuccess(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      backgroundColor: Colors.green.shade800,
      icon: AppIcons.checkCircle,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackbar(
      context,
      message,
      backgroundColor: AppColors.redColor,
      icon: AppIcons.errorOutlined,
    );
  }

  static void _showSnackbar(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    required IconData icon,
  }) {
    final mediaQuery = MediaQuery.of(context);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: AppColors.whiteColor, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bold14White,
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.up,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.only(
            bottom: mediaQuery.size.height - mediaQuery.viewInsets.bottom - 150,
            left: 16,
            right: 16,
          ),
        ),
      );
  }
}
