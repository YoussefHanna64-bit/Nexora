import 'package:flutter/material.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/profile/presentation/widgets/profile_image.dart';

class ProfileHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final Color? subtitleColor;
  final VoidCallback onTap;
  final Widget? extraWidget;

  const ProfileHeader(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle,
      this.imageUrl,
      this.subtitleColor,
      required this.onTap,
      this.extraWidget});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        ProfileImage(
          icon: icon,
          imageUrl: imageUrl,
          onTap: onTap,
        ),
        const SizedBox(height: 16),
        Text(title,
            style: AppTextStyles.extraBold24Black.copyWith(color: onSurface)),
        const SizedBox(height: 4),
        Text(subtitle, style: AppTextStyles.regular14Grey),
        if (extraWidget != null) ...[
          const SizedBox(height: 12),
          extraWidget!,
        ],
      ],
    );
  }
}
