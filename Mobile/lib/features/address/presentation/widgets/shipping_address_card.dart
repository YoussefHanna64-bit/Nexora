import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class ShippingAddressCard extends StatelessWidget {
  final ShippingAddress address;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ShippingAddressCard(
      {super.key, required this.address, this.trailing, this.onTap});

  IconData _icon(String label) {
    switch (label.toLowerCase()) {
      case "home":
        return AppIcons.homeOutlined;
      case "work":
        return AppIcons.workOutlined;
      default:
        return AppIcons.locationOnOutlined;
    }
  }

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
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(40),
            shape: BoxShape.circle,
          ),
          child: Icon(_icon(address.label), color: AppColors.primary),
        ),
        title: Row(
          children: [
            Text(
              address.label,
              style: AppTextStyles.bold14Black.copyWith(color: onSurface),
            ),
            const SizedBox(width: 8),
            if (address.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.greenColor.withAlpha(40),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "Default",
                  style: AppTextStyles.bold10Green,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "${address.street}${address.apartment != null && address.apartment!.isNotEmpty ? ", ${address.apartment}" : ""}",
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              "${address.city}, ${address.postalCode}",
              style: AppTextStyles.regular14Grey.copyWith(color: onSurface),
            ),
            const SizedBox(height: 4),
            Text(address.phone,
                style: AppTextStyles.regular14Grey.copyWith(color: onSurface)),
          ],
        ),
        trailing: trailing,
      ),
    );
  }
}
