import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class ShippingAddressCard extends StatelessWidget {
  final ShippingAddress address;
  final Widget? trailing;
  final VoidCallback? onTap;

  const ShippingAddressCard(
      {super.key, required this.address, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    IconData icon;
    String labelText;

    switch (address.label.toLowerCase()) {
      case "home":
        icon = AppIcons.homeOutlined;
        labelText = l10n.homeLabel;
        break;
      case "work":
        icon = AppIcons.workOutlined;
        labelText = l10n.workLabel;
        break;
      default:
        icon = AppIcons.locationOnOutlined;
        labelText = l10n.otherLabel;
    }

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
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Row(
          children: [
            Text(
              labelText,
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
                child: Text(
                  l10n.defaultLabel,
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
