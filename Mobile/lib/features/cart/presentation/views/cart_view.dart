import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/models/cart_model.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_bottom_sheet_container.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/order_summary_card.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';
import 'package:nexora/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.cart),
      body: BlocConsumer<CartCubit, CartState>(
          listenWhen: (previous, current) =>
              current is CartActionSuccess || current is CartActionError,
          listener: (context, state) {
            if (state is CartActionSuccess) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              String translatedMessage = "";

              if (state.successMessage == "itemAddedToCart") {
                translatedMessage = l10n.itemAddedToCart;
              } else if (state.successMessage == "itemRemoved") {
                translatedMessage = l10n.itemRemoved;
              } else {
                translatedMessage = state.successMessage;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(translatedMessage),
                  backgroundColor: AppColors.primary,
                ),
              );
            } else if (state is CartActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: AppColors.redColor,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is CartLoading ||
              current is CartSuccess ||
              current is CartError ||
              current is CartInitial,
          builder: (context, state) {
            if (state is CartError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<CartCubit>().fetchCart();
                },
              );
            }

            final bool isLoading = state is CartLoading || state is CartInitial;

            final cartItems =
                isLoading ? dummyCart.items : (state as CartSuccess).cart.items;

            final totalPrice =
                isLoading ? 0.0 : (state as CartSuccess).cart.totalPrice;

            if (!isLoading && cartItems.isEmpty) {
              return Center(
                child: Text(l10n.cartEmpty,
                    style: AppTextStyles.regular14Grey,
                    textAlign: TextAlign.center),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: Skeletonizer(
                    enabled: isLoading,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == cartItems.length) {
                          return OrderSummaryCard(
                            subtotal: totalPrice,
                            shippingFee: 0,
                          );
                        }

                        final cartItem = cartItems[index];
                        final product = cartItem.product;
                        final quantity = cartItem.quantity;

                        return CartItemCard(
                          product: product,
                          quantity: quantity,
                          onIncrement: isLoading
                              ? () {}
                              : () {
                                  context.read<CartCubit>().updateQuantity(
                                      cartItem.id, quantity + 1);
                                },
                          onDecrement: isLoading
                              ? () {}
                              : () {
                                  context.read<CartCubit>().updateQuantity(
                                      cartItem.id, quantity - 1);
                                },
                          onRemove: isLoading
                              ? () {}
                              : () {
                                  context
                                      .read<CartCubit>()
                                      .removeCartItem(cartItem.id);
                                },
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }),
      bottomNavigationBar:
          BlocBuilder<CartCubit, CartState>(builder: (context, state) {
        if (state is CartSuccess && state.cart.items.isNotEmpty) {
          final totalPrice = state.cart.totalPrice;

          return CustomBottomSheetContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(l10n.total,
                        style: AppTextStyles.bold18Black
                            .copyWith(color: onSurface)),
                    Text("\$${totalPrice.toStringAsFixed(2)}",
                        style: AppTextStyles.extraBold24Black
                            .copyWith(color: onSurface)),
                  ],
                ),
                const SizedBox(height: 16),
                CustomPrimaryButton(
                  buttonText: l10n.proceedToCheckout,
                  onPressed: () {
                    context.push(Routes.checkout);
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
