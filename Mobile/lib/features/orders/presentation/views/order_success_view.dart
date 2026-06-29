import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';

class OrderSuccessView extends StatelessWidget {
  final Order? order;
  const OrderSuccessView({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    AppIcons.checkCircle,
                    color: AppColors.greenColor,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  order?.id != null
                      ? l10n.orderConfirmedWithId(order!.id)
                      : l10n.orderConfirmed,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold24Black.copyWith(color: onSurface),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.thankYouForYourPurchase,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular14Grey,
                ),
                const Spacer(),
                CustomPrimaryButton(
                  buttonText: l10n.continueShopping,
                  onPressed: () {
                    context.go(Routes.home);
                  },
                  height: 56,
                ),
                const SizedBox(height: 16),
                CustomPrimaryButton(
                  buttonText: l10n.trackMyOrder,
                  onPressed: () {
                    context.push(Routes.myOrders);
                  },
                  isOutlined: true,
                  height: 56,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
