import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/presentation/widgets/order_status_badge.dart';

class OrderListItem extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderListItem({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.orderIdShort(order.id.substring(0, 8)),
                style: AppTextStyles.bold16Black.copyWith(color: onSurface)),
            OrderStatusBadge(status: order.status),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat("dd MMM yyyy, hh:mm a",
                        Localizations.localeOf(context).languageCode)
                    .format(order.createdAt),
                style: AppTextStyles.regular12Grey.copyWith(color: onSurface),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "${l10n.itemsCount(order.cartItems.length)} • ",
                        style: AppTextStyles.regular14Grey
                            .copyWith(color: onSurface),
                      ),
                      Icon(
                        order.paymentMethodType == "card"
                            ? AppIcons.creditCard
                            : AppIcons.money,
                        size: 16,
                        color: AppColors.greyColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.paymentMethodType == "card"
                            ? l10n.card
                            : l10n.cash,
                        style: AppTextStyles.regular14Grey
                            .copyWith(color: onSurface),
                      ),
                    ],
                  ),
                  Text("\$${order.totalOrderPrice.toStringAsFixed(2)}",
                      style: AppTextStyles.bold16Primary),
                ],
              ),
            ],
          ),
        ),
        trailing: const Icon(
          AppIcons.arrowForward,
          size: 16,
          color: AppColors.greyColor,
        ),
      ),
    );
  }
}
