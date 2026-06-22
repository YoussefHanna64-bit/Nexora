import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class PaymentMethodTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;

  const PaymentMethodTile(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon,
      required this.value,
      required this.groupValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final dividerColor = Theme.of(context).dividerColor;

    return RadioListTile<String>(
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(title,
          style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
      subtitle: Text(subtitle, style: AppTextStyles.regular12Grey),
      secondary: Icon(icon,
          color: isSelected ? AppColors.primary : AppColors.greyColor),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      activeColor: AppColors.primary,
      tileColor:
          isSelected ? AppColors.primary.withAlpha(15) : Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isSelected ? AppColors.primary : dividerColor),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
