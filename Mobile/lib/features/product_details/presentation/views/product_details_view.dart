import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/quantity_selector.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/product_details/presentation/widgets/price_bottom_bar.dart';
import 'package:nexora/features/product_details/presentation/widgets/product_image_carousel.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';

class ProductDetailsView extends StatefulWidget {
  final Product product;
  const ProductDetailsView({super.key, required this.product});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() => quantity++);
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final h = MediaQuery.of(context).size.height;

    final priceBeforeDiscount =
        widget.product.price / (1 - (widget.product.discount) / 100);
    final totalPrice = (widget.product.price * quantity).toDouble();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withAlpha(204),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(AppIcons.arrowBack, color: onSurface, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withAlpha(204),
                shape: BoxShape.circle,
              ),
              child: BlocBuilder<WishlistCubit, WishlistState>(
                builder: (context, state) {
                  final isFavorite = context
                      .read<WishlistCubit>()
                      .isInWishlist(widget.product.id);

                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : AppIcons.favoritesBorder,
                      color: isFavorite ? Colors.red : onSurface,
                    ),
                    onPressed: () {
                      context
                          .read<WishlistCubit>()
                          .toggleItem(widget.product.id);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: h * 0.45,
              child: ProductImageCarousel(images: widget.product.images),
            ),
            Container(
              transform: Matrix4.translationValues(0, -20, 0),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.categoryName.toUpperCase(),
                    style: AppTextStyles.bold12Primary.copyWith(
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    widget.product.name,
                    style: AppTextStyles.extraBold24Black.copyWith(
                      color: onSurface,
                    ),
                  ),
                  SizedBox(height: h * 0.005),
                  Row(
                    children: [
                      const Icon(AppIcons.star,
                          color: AppColors.goldColor, size: 20),
                      const SizedBox(width: 4),
                      Text(widget.product.ratingRate.toString(),
                          style: AppTextStyles.bold14Black
                              .copyWith(color: onSurface)),
                      const SizedBox(width: 8),
                      Text(l10n.reviewsCount(widget.product.ratingCount),
                          style: AppTextStyles.regular14Grey),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.product.discount != 0)
                            Text(
                              '\$${priceBeforeDiscount.toStringAsFixed(2)}',
                              style: AppTextStyles.regular14Grey.copyWith(
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            '\$${widget.product.price}',
                            style: AppTextStyles.extraBold24Primary,
                          ),
                        ],
                      ),
                      QuantitySelector(
                        quantity: quantity,
                        onIncrement: incrementQuantity,
                        onDecrement: decrementQuantity,
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.02),
                  Text(l10n.description,
                      style:
                          AppTextStyles.bold16White.copyWith(color: onSurface)),
                  const SizedBox(height: 8),
                  Text(
                    widget.product.description,
                    style: AppTextStyles.regular14Grey,
                  ),
                  SizedBox(height: h * 0.02),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PriceBottomBar(
        totalPrice: totalPrice,
        onPressed: () {
          context.read<CartCubit>().addToCart(
                widget.product.id,
                quantity: quantity,
              );
        },
      ),
    );
  }
}
