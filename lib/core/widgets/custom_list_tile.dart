import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final bool showTrailing;
  final String? trailingText;

  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
    this.showTrailing = true,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Theme.of(context).colorScheme.onSurface;

    final backgroundColor = color != null
        ? color!.withAlpha(25)
        : Theme.of(context).colorScheme.surface;

    final borderColor =
        color != null ? color!.withAlpha(76) : Theme.of(context).dividerColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: themeColor),
        ),
        title: Text(title,
            style: AppTextStyles.bold16Black.copyWith(color: themeColor)),
        trailing: showTrailing || trailingText != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingText != null) ...[
                    Text(
                      trailingText!,
                      style: AppTextStyles.regular14Grey,
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (showTrailing)
                    const Icon(
                      AppIcons.arrowForward,
                      size: 16,
                      color: AppColors.greyColor,
                    ),
                ],
              )
            : null,
        onTap: onTap,
        splashColor: color?.withAlpha(51),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
