import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final VoidCallback onTap;

  const CategoryCard(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CachedNetworkImage(
              width: 50,
              height: 50,
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(AppIcons.brokenImage,
                    size: 20, color: AppColors.greyColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.medium12Black
                  .copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ));
  }
}
