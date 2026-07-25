import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/features/settings/presentation/widgets/section_body.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.privacyPolicy,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.primary.withAlpha(60),
                ),
              ),
              child: Text(l10n.privacyLastUpdated,
                  style: AppTextStyles.bold14Primary),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.privacyIntroTitle,
              style: AppTextStyles.bold16Black.copyWith(color: onSurface),
            ),
            const SizedBox(height: 10),
            SectionBody(text: l10n.privacyIntroBody),
            const SizedBox(height: 28),
            Text(
              l10n.privacyDataTitle,
              style: AppTextStyles.bold16Black.copyWith(color: onSurface),
            ),
            const SizedBox(height: 10),
            SectionBody(text: l10n.privacyDataBody),
            const SizedBox(height: 28),
            Text(
              l10n.privacyPaymentsTitle,
              style: AppTextStyles.bold16Black.copyWith(color: onSurface),
            ),
            const SizedBox(height: 10),
            SectionBody(text: l10n.privacyPaymentsBody),
            const SizedBox(height: 28),
            Text(
              l10n.privacyContactTitle,
              style: AppTextStyles.bold16Black.copyWith(color: onSurface),
            ),
            const SizedBox(height: 10),
            SectionBody(text: l10n.privacyContactBody),
            const SizedBox(height: 40),
            Divider(color: AppColors.greyColor.withAlpha(60)),
            const SizedBox(height: 12),
            Center(
              child: Text(
                l10n.privacyFooter,
                style: AppTextStyles.regular12Grey,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
