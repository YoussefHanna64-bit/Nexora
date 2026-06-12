import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/product_grid.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final wishList = dummyProducts.toList();

    return Scaffold(
      appBar: CustomAppBar(title: l10n.wishlist),
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
