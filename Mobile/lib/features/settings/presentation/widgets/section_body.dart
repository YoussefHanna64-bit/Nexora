import 'package:flutter/material.dart';
import 'package:nexora/core/theme/text_styles.dart';

class SectionBody extends StatelessWidget {
  final String text;

  const SectionBody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Text(
        text,
        style: AppTextStyles.regular14Grey.copyWith(
          color: onSurface,
          height: 1.8,
        ),
      ),
    );
  }
}
