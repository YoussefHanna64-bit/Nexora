import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_bottom_sheet_container.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';
import 'package:nexora/features/cart/presentation/widgets/cart_item_card.dart';

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
        body: BlocBuilder<CartCubit, CartState>(
            buildWhen: (previous, current) =>
                current is CartUpdated || current is CartInitial,
            builder: (context, state) {
              final cartItems = state is CartUpdated ? state.cart.items : [];
              final totalPrice =
                  state is CartUpdated ? state.cart.totalPrice : 0.0;

              if (cartItems.isEmpty) {
                return Center(
                  child:
                      Text(l10n.cartEmpty, style: AppTextStyles.regular14Grey),
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: cartItems.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (index == cartItems.length) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: Theme.of(context).dividerColor),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(l10n.subtotal,
                                        style: AppTextStyles.regular14Grey),
                                    Text('\$${totalPrice.toStringAsFixed(2)}',
                                        style: AppTextStyles.bold14Black
                                            .copyWith(color: onSurface)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(l10n.shipping,
                                        style: AppTextStyles.regular14Grey),
                                    Text(l10n.free,
                                        style: AppTextStyles.bold16Primary),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }

                        final cartItem = cartItems[index];
                        final product = cartItem.product;
                        final quantity = cartItem.quantity;

                        return CartItemCard(
                          product: product,
                          quantity: quantity,
                          onIncrement: () {
                            setState(() {
                              context
                                  .read<CartCubit>()
                                  .incrementQuantity(cartItem.product.id);
                            });
                          },
                          onDecrement: () {
                            if (quantity > 1) {
                              setState(() {
                                context
                                    .read<CartCubit>()
                                    .decrementQuantity(cartItem.product.id);
                              });
                            }
                          },
                          onRemove: () {
                            setState(() {
                              context
                                  .read<CartCubit>()
                                  .removeFromCart(cartItem.product.id);
                            });
                          },
                        );
                      },
                    ),
                  ),
                  CustomBottomSheetContainer(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(l10n.total,
                                style: AppTextStyles.bold18Black
                                    .copyWith(color: onSurface)),
                            Text('\$${totalPrice.toStringAsFixed(2)}',
                                style: AppTextStyles.extraBold24Black
                                    .copyWith(color: onSurface)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomPrimaryButton(
                          buttonText: l10n.proceedToCheckout,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }));
  }
}
