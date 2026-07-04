import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';

class EmptyAddressState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyAddressState({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              l10n.noAddressesYet,
              style: AppTextStyles.bold20White.copyWith(color: onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noAddressesSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
            ),
            const SizedBox(height: 24),
            CustomPrimaryButton(
              width: null,
              onPressed: onAddPressed,
              buttonText: l10n.addAddress,
              icon: AppIcons.add,
            ),
          ],
        ),
      ),
    );
  }
}
