import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/features/product/presentation/widgets/product_card.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/cart/presentation/manager/cart_state.dart';
import 'package:nexora/features/product/domain/entities/product.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_cubit.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final bool asSliver;

  const ProductGrid({
    super.key,
    required this.products,
    this.asSliver = false,
  });

  static const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 0.75,
  );

  static void _onCartState(
      BuildContext context, CartState state, AppLocalizations l10n) {
    if (state is CartActionSuccess) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      String msg;
      if (state.successMessage == "itemAddedToCart") {
        msg = l10n.itemAddedToCart;
      } else if (state.successMessage == "itemRemoved") {
        msg = l10n.itemRemoved;
      } else {
        msg = state.successMessage;
      }
      AppSnackbars.showSuccess(context, msg);
    } else if (state is CartActionError) {
      AppSnackbars.showError(context, state.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    bool listenWhen(CartState previous, CartState current) =>
        current is CartActionSuccess || current is CartActionError;

    void listener(BuildContext context, CartState state) =>
        _onCartState(context, state, l10n);

    if (asSliver) {
      return SliverMainAxisGroup(slivers: [
        SliverToBoxAdapter(
          child: BlocListener<CartCubit, CartState>(
            listenWhen: listenWhen,
            listener: listener,
            child: const SizedBox.shrink(),
          ),
        ),
        SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _ProductItem(product: products[index]),
            childCount: products.length,
          ),
          gridDelegate: _gridDelegate,
        ),
      ]);
    }

    return BlocListener<CartCubit, CartState>(
      listenWhen: listenWhen,
      listener: listener,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: _gridDelegate,
        itemCount: products.length,
        itemBuilder: (context, index) => _ProductItem(product: products[index]),
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final Product product;
  const _ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<WishlistCubit, WishlistState, bool>(
      selector: (state) {
        return context.read<WishlistCubit>().isInWishlist(product.id);
      },
      builder: (context, isFavorite) {
        return ProductCard(
          brand: product.brand.name,
          name: product.name,
          price: product.price,
          isFavorite: isFavorite,
          discount: product.discount,
          imageUrl: product.thumbnail,
          onTap: () {
            context.push(Routes.productDetails, extra: product.id);
          },
          onFavoriteTap: () {
            context.read<WishlistCubit>().toggleItem(product.id);
          },
          onAddTap: () {
            context.read<CartCubit>().addToCart(product.id);
          },
        );
      },
    );
  }
}
