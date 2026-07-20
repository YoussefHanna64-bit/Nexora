import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final double iconSize;
  final bool isCompact;

  const CustomErrorWidget(
      {super.key,
      required this.message,
      this.onRetry,
      this.iconSize = 64,
      this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    if (isCompact) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                style: AppTextStyles.regular14Grey
                    .copyWith(color: AppColors.redColor),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null)
                TextButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(AppIcons.refresh,
                      color: AppColors.primary, size: 16),
                  label:
                      Text(l10n.tapToRetry, style: AppTextStyles.bold14Primary),
                ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              AppIcons.errorOutlined,
              size: iconSize,
              color: AppColors.redColor,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: AppTextStyles.bold16Black.copyWith(color: onSurface),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(AppIcons.refresh,
                    color: AppColors.primary, size: 20),
                label:
                    Text(l10n.tapToRetry, style: AppTextStyles.bold16Primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
