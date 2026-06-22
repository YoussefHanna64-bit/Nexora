import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/orders/presentation/manager/checkout/checkout_cubit.dart';
import 'package:nexora/features/orders/presentation/manager/checkout/checkout_state.dart';
import 'package:nexora/features/orders/presentation/widgets/payment_method_tile.dart';
import 'package:nexora/features/orders/presentation/widgets/shipping_address_card.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPaymentMethod = "card";

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Checkout",
        showBackButton: true,
      ),
      body: BlocConsumer<CheckoutCubit, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.redColor),
            );
          } else if (state is CheckoutSuccess) {
            context.read<CartCubit>().fetchCart();

            context.go(Routes.home);
          }
        },
        builder: (context, state) {
          final isLoading = state is CheckoutLoading;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Shipping Address",
                        style: AppTextStyles.bold18Black
                            .copyWith(color: onSurface)),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Change"),
                    ),
                  ],
                ),
                ShippingAddressCard(address: currentAddress),
                const SizedBox(height: 32),
                Text("Payment Method",
                    style:
                        AppTextStyles.bold18Black.copyWith(color: onSurface)),
                const SizedBox(height: 12),
                PaymentMethodTile(
                  title: "Credit/Debit Card",
                  subtitle: "Pay securely with Stripe",
                  icon: Icons.credit_card,
                  value: "card",
                  groupValue: selectedPaymentMethod,
                  onChanged: (val) =>
                      setState(() => selectedPaymentMethod = val!),
                ),
                const SizedBox(height: 8),
                PaymentMethodTile(
                  title: "Cash on Delivery",
                  subtitle: "Pay when your order arrives",
                  icon: Icons.money,
                  value: "cash",
                  groupValue: selectedPaymentMethod,
                  onChanged: (val) =>
                      setState(() => selectedPaymentMethod = val!),
                ),
                const Spacer(),
                CustomPrimaryButton(
                  buttonText: "Place Order",
                  onPressed: () {
                    context.read<CheckoutCubit>().processCheckout(
                          shippingAddress: currentAddress,
                          paymentMethodType: selectedPaymentMethod,
                        );
                  },
                  isLoading: isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
