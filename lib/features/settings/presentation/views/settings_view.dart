import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_switch_tile.dart';
import 'package:nexora/core/widgets/custom_list_tile.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDarkMode = false;
  String currentLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

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
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
            CustomListTile(
              icon: AppIcons.languageOutlined,
              title: l10n.language,
              trailingText: currentLanguage,
              onTap: () {},
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
