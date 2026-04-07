import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class ProductCard extends StatelessWidget {
  final String category;
  final String name;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;
  final bool isFavorite;
  final double? discount;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddTap;

  const ProductCard({
    super.key,
    required this.category,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.onTap,
    this.isFavorite = false,
    this.discount,
    this.onFavoriteTap,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).dividerColor)),
        clipBehavior: Clip.antiAlias,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (discount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.redColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '-${discount!.toInt()}%',
                            style: AppTextStyles.bold10White,
                          ),
                        )
                      else
                        const SizedBox(),
                      GestureDetector(
                        onTap: onFavoriteTap,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: AppColors.whiteColor,
                          child: Icon(
                              isFavorite
                                  ? AppIcons.favorites
                                  : AppIcons.favoritesBorder,
                              size: 16,
                              color: isFavorite
                                  ? AppColors.redColor
                                  : AppColors.greyColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.toUpperCase(),
                    style: AppTextStyles.bold10White.copyWith(
                      color: AppColors.greyColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    name,
                    style: AppTextStyles.bold14Black.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$$price', style: AppTextStyles.bold16Primary),
                      GestureDetector(
                        onTap: onAddTap,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(AppIcons.add,
                              color: AppColors.whiteColor, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
