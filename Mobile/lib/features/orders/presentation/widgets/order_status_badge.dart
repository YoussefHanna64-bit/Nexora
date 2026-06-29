import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    Color color;
    String statusText;
    switch (status.toLowerCase()) {
      case "pending":
        color = AppColors.goldColor;
        statusText = l10n.statusPending;
        break;
      case "shipped":
        color = AppColors.secondary;
        statusText = l10n.statusShipped;
        break;
      case "delivered":
        color = AppColors.greenColor;
        statusText = l10n.statusDelivered;
        break;
      case "canceled":
        color = AppColors.redColor;
        statusText = l10n.statusCanceled;
        break;
      default:
        color = AppColors.greyColor;
        statusText = l10n.statusUnknown;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(50),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusText.toUpperCase(),
        style:
            TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
