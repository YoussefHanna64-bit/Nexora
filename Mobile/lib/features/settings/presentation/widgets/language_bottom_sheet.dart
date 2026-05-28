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
    final currentLang = context.watch<LanguageCubit>().state.languageCode;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final surface = Theme.of(context).colorScheme.surface;
    final divider = Theme.of(context).dividerColor;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: divider),
              ),
              child: Text(
                'EN',
                style: AppTextStyles.bold12Black.copyWith(
                  color: onSurface.withAlpha(180),
                ),
              ),
            ),
            title: const Text('English'),
            trailing: currentLang == 'en'
                ? const Icon(AppIcons.check, color: AppColors.primary)
                : null,
            onTap: () {
              context.read<LanguageCubit>().changeLanguage('en');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: divider),
              ),
              child: Text(
                'AR',
                style: AppTextStyles.bold12Black.copyWith(
                  color: onSurface.withAlpha(180),
                ),
              ),
            ),
            title: const Text('العربية'),
            trailing: currentLang == 'ar'
                ? const Icon(AppIcons.check, color: AppColors.primary)
                : null,
            onTap: () {
              context.read<LanguageCubit>().changeLanguage('ar');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
