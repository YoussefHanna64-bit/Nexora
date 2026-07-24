import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/localization/language_cubit.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLang = Localizations.localeOf(context).languageCode;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface = Theme.of(context).colorScheme.surface;
    final divider = Theme.of(context).dividerColor;
    final isEngSelected = currentLang == "en";
    final isArSelected = currentLang == "ar";

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    isEngSelected ? AppColors.primary.withAlpha(30) : surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isEngSelected ? AppColors.primary : divider),
              ),
              child: Text(
                "EN",
                style: isEngSelected
                    ? AppTextStyles.bold12Primary
                    : AppTextStyles.bold12Black.copyWith(
                        color: onSurface.withAlpha(180),
                      ),
              ),
            ),
            title: const Text("English"),
            trailing: isEngSelected
                ? const Icon(AppIcons.check, color: AppColors.primary)
                : null,
            onTap: () {
              context.read<LanguageCubit>().changeLanguage("en");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isArSelected ? AppColors.primary.withAlpha(30) : surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: isArSelected ? AppColors.primary : divider),
              ),
              child: Text(
                "AR",
                style: isArSelected
                    ? AppTextStyles.bold12Primary
                    : AppTextStyles.bold12Black.copyWith(
                        color: onSurface.withAlpha(180),
                      ),
              ),
            ),
            title: const Text("العربية"),
            trailing: isArSelected
                ? const Icon(AppIcons.check, color: AppColors.primary)
                : null,
            onTap: () {
              context.read<LanguageCubit>().changeLanguage("ar");
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
