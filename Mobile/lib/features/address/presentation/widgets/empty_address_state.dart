import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class EmptyAddressState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyAddressState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(AppIcons.locationOffOutlined,
                size: 80, color: AppColors.lightGrey),
            const SizedBox(height: 16),
            Text(
              "No Addresses Found",
              style: AppTextStyles.bold20White.copyWith(color: onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              "There are no shipping addresses yet. Add one to make checkout faster",
              textAlign: TextAlign.center,
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: onAddPressed,
              icon: const Icon(AppIcons.add, color: AppColors.whiteColor),
              label: const Text("Add New Address",
                  style: AppTextStyles.bold16White),
            )
          ],
        ),
      ),
    );
  }
}
