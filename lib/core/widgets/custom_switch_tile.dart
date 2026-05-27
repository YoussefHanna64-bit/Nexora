import 'package:flutter/material.dart';
import 'package:nexora/core/theme/text_styles.dart';

class CustomSwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchTile(
      {super.key,
      required this.icon,
      required this.title,
      required this.value,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Icon(icon, color: onSurface),
        ),
        title: Text(title,
            style: AppTextStyles.bold16Black.copyWith(color: onSurface)),
        trailing: Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
