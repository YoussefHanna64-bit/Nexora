import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_images.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/features/settings/presentation/widgets/section_body.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_list_tile.dart';

class AboutNexoraView extends StatelessWidget {
  const AboutNexoraView({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.aboutNexora,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(25),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        AppImages.nexora,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Image.asset(
                    AppImages.nexoraBranding,
                    fit: BoxFit.cover,
                    height: 90,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "v1.0.0",
                    style: AppTextStyles.regular14Grey,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              l10n.developerStory,
              style: AppTextStyles.bold18Black.copyWith(color: onSurface),
            ),
            const SizedBox(height: 12),
            SectionBody(text: l10n.developerStoryContent),
            const SizedBox(height: 32),
            Text(
              l10n.connect,
              style: AppTextStyles.bold18Black.copyWith(color: onSurface),
            ),
            const SizedBox(height: 12),
            CustomListTile(
              icon: AppIcons.github,
              title: l10n.viewSourceOnGithub,
              color: onSurface,
              onTap: () => _launchUrl("https://github.com/YoussefHanna64-bit"),
            ),
            CustomListTile(
              icon: AppIcons.email,
              title: l10n.contactDeveloper,
              color: onSurface,
              onTap: () => _launchUrl("mailto:youssef.hanna.223175@gmail.com"),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
