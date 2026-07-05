import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/localization/language_cubit.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/utils/app_dialogs.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/order_summary_card.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/presentation/manager/order_history/order_history_cubit.dart';
import 'package:nexora/features/orders/presentation/widgets/order_product_tile.dart';
import 'package:nexora/features/orders/presentation/widgets/order_status_badge.dart';
import 'package:nexora/features/address/presentation/widgets/shipping_address_card.dart';

class OrderDetailsView extends StatelessWidget {
  final Order order;

  const OrderDetailsView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final bool canCancel =
        order.status == "pending" || order.status == "processing";
    final bool isDelivered = order.status == "delivered";
    final bool isCanceled = order.status == "canceled";

    return Scaffold(
      appBar: CustomAppBar(title: l10n.orderDetails, showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.orderIdFull(order.id),
                style: AppTextStyles.bold16Black.copyWith(color: onSurface)),
            const SizedBox(height: 4),
            Text(
              l10n.placedOn(DateFormat("dd MMM yyyy, hh:mm a",
                      context.read<LanguageCubit>().state.languageCode)
                  .format(order.createdAt)),
              style: AppTextStyles.regular14Grey,
            ),
            const SizedBox(height: 12),
            OrderStatusBadge(status: order.status),
            const Divider(height: 32),
            Text(l10n.items,
                style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
            ...order.cartItems.map((item) => OrderProductTile(
                  item: item,
                  isDelivered: isDelivered,
                )),
            const Divider(height: 32),
            Text(l10n.paymentMethod,
                style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  order.paymentMethodType == "card"
                      ? AppIcons.creditCard
                      : AppIcons.money,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  order.paymentMethodType == "card"
                      ? l10n.creditDebitCard
                      : l10n.cashOnDelivery,
                  style: AppTextStyles.bold14Black.copyWith(color: onSurface),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(l10n.orderSummary,
                style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
            const SizedBox(height: 12),
            OrderSummaryCard(
              subtotal: order.totalOrderPrice,
              total: order.totalOrderPrice,
            ),
            const SizedBox(height: 24),
            Text(l10n.shippingAddress,
                style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
            const SizedBox(height: 12),
            ShippingAddressCard(address: order.shippingAddress),
            const SizedBox(height: 48),
            if (canCancel)
              CustomPrimaryButton(
                buttonText: l10n.cancelOrder,
                outlineColor: AppColors.redColor,
                isOutlined: true,
                onPressed: () => _cancelConfirmation(context),
              )
            else if (isCanceled)
              Center(
                child: Text(l10n.orderHasBeenCanceled,
                    style: TextStyle(color: AppColors.redColor)),
              )
          ],
        ),
      ),
    );
  }

  void _cancelConfirmation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    AppDialogs.showConfirmDialog(
      context,
      title: l10n.cancelOrderQuestion,
      content: l10n.cancelOrderConfirmationText,
      cancelText: l10n.noKeepIt,
      confirmText: l10n.yesCancel,
      isDanger: true,
      onConfirm: () {
        context.read<OrderHistoryCubit>().cancelOrder(order.id);
        context.pop();
      },
    );
  }
}
