import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_bottom_sheet_container.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';

class PriceBottomBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onPressed;
  const PriceBottomBar(
      {super.key, required this.totalPrice, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return SafeArea(
      child: CustomBottomSheetContainer(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.totalPrice,
                      style: AppTextStyles.regular12Black
                          .copyWith(color: onSurface)),
                  FittedBox(
                    child: Text('\$${totalPrice.toStringAsFixed(2)}',
                        style: AppTextStyles.extraBold24Black
                            .copyWith(color: onSurface)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: CustomPrimaryButton(
                buttonText: l10n.addToCart,
                onPressed: onPressed,
              ),
            )
          ],
        ),
      ),
    );
  }
}
