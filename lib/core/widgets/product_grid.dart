import 'package:flutter/material.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/widgets/product_card.dart';

class ProductGrid extends StatelessWidget {
  final List<ProductModel> products;
  const ProductGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
        return ProductCard(
          category: product.category,
          name: product.name,
          price: product.price,
          isFavorite: product.isFavorite,
          discount: product.discount,
          imageUrl: product.imageUrl,
          onTap: () {},
          onFavoriteTap: () {},
          onAddTap: () {},
        );
      },
    );
  }
}
