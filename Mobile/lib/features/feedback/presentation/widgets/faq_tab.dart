import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class FaqTab extends StatelessWidget {
  const FaqTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final List<({String question, String answer})> faqs = [
      (question: l10n.faqQ1, answer: l10n.faqA1),
      (question: l10n.faqQ2, answer: l10n.faqA2),
      (question: l10n.faqQ3, answer: l10n.faqA3),
      (question: l10n.faqQ4, answer: l10n.faqA4),
      (question: l10n.faqQ5, answer: l10n.faqA5),
    ];

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: faqs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final faq = faqs[index];
        return ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Theme.of(context).dividerColor),
          ),
          title: Text(
            faq.question,
            style: AppTextStyles.bold14Black.copyWith(color: onSurface),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.greyColor,
          children: [
            Text(
              faq.answer,
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
