import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/models/cart_model.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_bottom_sheet_container.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
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
      body: dummyCart.items.isEmpty
          ? Center(
              child: Text(
                l10n.cartEmpty,
                style: AppTextStyles.regular14Grey,
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: dummyCart.items.length + 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == dummyCart.items.length) {
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
                                  Text(
                                      '\$${dummyCart.totalPrice.toStringAsFixed(2)}',
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

                      final cartItem = dummyCart.items[index];
                      final product = cartItem.product;
                      final quantity = cartItem.quantity;

                      return CartItemCard(
                        product: product,
                        quantity: quantity,
                        onIncrement: () {
                          setState(() {
                            cartItem.quantity += 1;
                          });
                        },
                        onDecrement: () {
                          if (quantity > 1) {
                            setState(() {
                              cartItem.quantity -= 1;
                            });
                          }
                        },
                        onRemove: () {
                          setState(() {
                            dummyCart.items.remove(cartItem);
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
                          Text('\$${dummyCart.totalPrice.toStringAsFixed(2)}',
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
            ),
    );
  }
}
