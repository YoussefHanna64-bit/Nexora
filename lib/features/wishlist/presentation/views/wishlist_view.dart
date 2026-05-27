import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/product_grid.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final wishList =
        dummyProducts.where((product) => product.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          l10n.wishlist,
          style: AppTextStyles.bold20White.copyWith(
            color: onSurface,
          ),
        ),
      ),
      body: wishList.isEmpty
          ? Center(
              child: Text(
                l10n.wishlistEmpty,
                style: AppTextStyles.regular14Grey,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ProductGrid(products: wishList),
                ],
              ),
            ),
    );
  }
}
