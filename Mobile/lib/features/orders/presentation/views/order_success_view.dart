import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';

class OrderSuccessView extends StatelessWidget {
  final Order? order;
  const OrderSuccessView({super.key, this.order});

  @override
  Widget build(BuildContext context) {
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
                    color: Colors.green.withAlpha(26),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 100,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  order?.id != null
                      ? "Order #${order!.id} Confirmed!"
                      : "Order Confirmed!",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold24Black.copyWith(color: onSurface),
                ),
                const SizedBox(height: 16),
                Text(
                  "Thank you for your purchase. We have received your order and will begin processing it shortly.",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular14Grey,
                ),
                const Spacer(),
                CustomPrimaryButton(
                  buttonText: "Continue Shopping",
                  onPressed: () {
                    context.go(Routes.home);
                  },
                  height: 56,
                ),
                const SizedBox(height: 16),
                CustomPrimaryButton(
                  buttonText: "Track My Order",
                  onPressed: () {
                    context.go(Routes.home);
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
