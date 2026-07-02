import 'package:flutter/material.dart';
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
    return ListTile(
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
      title: Text(item.productName, style: AppTextStyles.bold14Black),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Qty: ${item.quantity} • \$${item.price}",
              style: AppTextStyles.regular12Grey),
          if (isDelivered) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Rating feature coming soon")),
                );
              },
              child: Row(
                children: [
                  Icon(Icons.star, color: AppColors.goldColor, size: 16),
                  const Text("Leave a Review",
                      style: AppTextStyles.bold12Amber),
                ],
              ),
            )
          ]
        ],
      ),
    );
  }
}
