import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/widgets/product_card.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CartCubit, CartState>(
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
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return BlocSelector<WishlistCubit, WishlistState, bool>(
              selector: (state) {
            return context.read<WishlistCubit>().isInWishlist(product.id);
          }, builder: (context, isFavorite) {
            return ProductCard(
              brand: product.brand,
              name: product.name,
              price: product.price,
              isFavorite: isFavorite,
              discount: product.discount,
              imageUrl: product.thumbnail,
              onTap: () {
                context.push(Routes.productDetails, extra: product);
              },
              onFavoriteTap: () {
                context.read<WishlistCubit>().toggleItem(product.id);
              },
              onAddTap: () {
                context.read<CartCubit>().addToCart(product.id);
              },
            );
          });
        },
      ),
    );
  }
}
