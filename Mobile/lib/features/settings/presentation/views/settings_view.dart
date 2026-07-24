import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/theme/theme_cubit.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_switch_tile.dart';
import 'package:nexora/core/widgets/custom_list_tile.dart';
import 'package:nexora/features/settings/presentation/widgets/language_bottom_sheet.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == "ar";

    return Scaffold(
      appBar: CustomAppBar(title: l10n.settings, showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.preferences,
                style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
            const SizedBox(height: 16),
            CustomSwitchTile(
              icon: AppIcons.darkModeOutlined,
              title: l10n.darkMode,
              value: isDark,
              onChanged: (value) {
                context.read<ThemeCubit>().toggleTheme(isDark);
              },
            ),
            CustomListTile(
              icon: AppIcons.languageOutlined,
              title: l10n.language,
              trailingText: isArabic ? "العربية" : "English",
              onTap: () {
                showModalBottomSheet(
                    showDragHandle: true,
                    context: context,
                    builder: (context) => const LanguageBottomSheet());
              },
            ),
            const SizedBox(height: 32),
            Text(l10n.support,
                style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
            const SizedBox(height: 16),
            CustomListTile(
              icon: AppIcons.helpOutline,
              title: l10n.helpCenter,
              onTap: () {},
            ),
            CustomListTile(
              icon: AppIcons.privacyTipOutlined,
              title: l10n.privacyPolicy,
              onTap: () {},
            ),
            CustomListTile(
              icon: AppIcons.infoOutline,
              title: l10n.aboutNexora,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
