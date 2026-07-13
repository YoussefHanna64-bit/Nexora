import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';

class ProfileImage extends StatelessWidget {
  final String? imageUrl;
  final IconData icon;
  final VoidCallback onTap;
  final double radius;

  const ProfileImage({
    super.key,
    this.imageUrl,
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
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withAlpha(25),
            ),
            child: ClipOval(
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? Center(
                      child: Icon(
                        AppIcons.profile,
                        size: radius,
                        color: AppColors.primary.withAlpha(100),
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Icon(
                        AppIcons.profile,
                        size: radius,
                        color: AppColors.primary.withAlpha(100),
                      ),
                    ),
            ),
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
