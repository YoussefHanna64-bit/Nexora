import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/text_styles.dart';

class OrderSummaryCard extends StatelessWidget {
  final num subtotal;
  final num shippingFee;
  final num? total;
  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    this.shippingFee = 0,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.subtotal, style: AppTextStyles.regular14Grey),
              Text("\$${subtotal.toStringAsFixed(2)}",
                  style: AppTextStyles.bold14Black.copyWith(color: onSurface)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.shipping, style: AppTextStyles.regular14Grey),
              Text(
                shippingFee == 0
                    ? l10n.free
                    : "\$${shippingFee.toStringAsFixed(2)}",
                style: shippingFee == 0
                    ? AppTextStyles.bold16Primary
                    : AppTextStyles.bold14Black.copyWith(color: onSurface),
              ),
            ],
          ),
          if (total != null) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.total,
                    style:
                        AppTextStyles.bold16Black.copyWith(color: onSurface)),
                Text("\$${total?.toStringAsFixed(2)}",
                    style:
                        AppTextStyles.bold18Black.copyWith(color: onSurface)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
