import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:nexora/core/routers/routes.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';

class OrderProductTile extends StatelessWidget {
  final OrderItem item;
  final bool isDelivered;

  const OrderProductTile(
      {super.key, required this.item, required this.isDelivered});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return ListTile(
      onTap: () {
        //  context.push(Routes.productDetails, extra: item.productId);
      },
      contentPadding: EdgeInsets.zero,
      leading: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: AppColors.lightGrey.withAlpha(128),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(item.productThumbnail, fit: BoxFit.cover),
        ),
      ),
      title: Text(item.productName,
          style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.qtyAndPrice(item.quantity, item.price),
              style: AppTextStyles.regular12Grey),
          if (isDelivered) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.ratingFeatureComingSoon)),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.star, color: AppColors.goldColor, size: 16),
                  Text(l10n.leaveReview, style: AppTextStyles.bold12Amber),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}
