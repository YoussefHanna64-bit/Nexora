import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/services/user_cache_service.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_error_widget.dart';
import 'package:nexora/core/widgets/quantity_selector.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product_details/product_details_cubit.dart';
import 'package:nexora/features/product/presentation/manager/product_details/product_details_state.dart';
import 'package:nexora/features/product/presentation/widgets/price_bottom_bar.dart';
import 'package:nexora/features/product/presentation/widgets/product_image_carousel.dart';
import 'package:nexora/features/product/presentation/widgets/product_reviews_list.dart';
import 'package:nexora/features/reviews/presentation/manager/review_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductDetailsView extends StatefulWidget {
  final String productId;

  const ProductDetailsView({super.key, required this.productId});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsCubit>().fetchProduct(widget.productId);
    context.read<ReviewCubit>().fetchProductReviews(widget.productId);
  }

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

    final String? currentUserId = GetIt.instance<UserCacheService>().userId;

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
                      .isInWishlist(widget.productId);

                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : AppIcons.favoritesBorder,
                      color: isFavorite ? Colors.red : onSurface,
                    ),
                    onPressed: () {
                      context
                          .read<WishlistCubit>()
                          .toggleItem(widget.productId);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
          builder: (context, state) {
        if (state is ProductDetailsError) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () {
              context
                  .read<ProductDetailsCubit>()
                  .fetchProduct(widget.productId);
            },
          );
        }

        final isLoading =
            state is ProductDetailsLoading || state is ProductDetailsInitial;
        final product = state is ProductDetailsLoaded
            ? state.product
            : Product.mockProducts[0];

        final priceBeforeDiscount =
            product.price / (1 - (product.discount) / 100);

        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: h * 0.45,
                  child: ProductImageCarousel(images: product.images),
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
                        product.brand.toUpperCase(),
                        style: AppTextStyles.bold12Primary.copyWith(
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: h * 0.01),
                      Text(
                        product.name,
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
                          Text(product.ratingRate.toString(),
                              style: AppTextStyles.bold14Black
                                  .copyWith(color: onSurface)),
                          const SizedBox(width: 8),
                          Text(l10n.reviewsCount(product.ratingCount),
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
                              if (product.discount != 0)
                                Text(
                                  '\$${priceBeforeDiscount.toStringAsFixed(2)}',
                                  style: AppTextStyles.regular14Grey.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              Text(
                                '\$${product.price}',
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
                          style: AppTextStyles.bold16White
                              .copyWith(color: onSurface)),
                      const SizedBox(height: 8),
                      Text(
                        product.description,
                        style: AppTextStyles.regular14Grey,
                      ),
                      SizedBox(height: h * 0.02),
                      Text(
                        l10n.ratingsAndReviews,
                        style: AppTextStyles.bold16White
                            .copyWith(color: onSurface),
                      ),
                      const SizedBox(height: 16),
                      ProductReviewsList(currentUserId: currentUserId),
                      SizedBox(height: h * 0.02),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar:
          BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
              builder: (context, state) {
        if (state is ProductDetailsLoaded) {
          final totalPrice = (state.product.price * quantity).toDouble();

          return PriceBottomBar(
            totalPrice: totalPrice,
            onPressed: () {
              context.read<CartCubit>().addToCart(
                    state.product.id,
                    quantity: quantity,
                  );
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
