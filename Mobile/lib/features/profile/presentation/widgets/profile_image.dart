import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final IconData icon;
  final VoidCallback onTap;
  final double radius;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.icon,
    required this.onTap,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: AppColors.primary.withAlpha(25),
            backgroundImage: NetworkImage(imageUrl),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.whiteColor),
          ),
        ],
      ),
    );
  }
}
