import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class ShippingAddressCard extends StatelessWidget {
  final ShippingAddress address;

  const ShippingAddressCard({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(40),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.location_on, color: AppColors.primary),
        ),
        title: Text(
          "${address.street}, ${address.apartment}",
          style: AppTextStyles.bold14Black.copyWith(color: onSurface),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "${address.city}, ${address.postalCode}",
              style: AppTextStyles.regular14Grey,
            ),
            const SizedBox(height: 4),
            Text(address.phone, style: AppTextStyles.regular14Grey),
          ],
        ),
      ),
    );
  }
}
