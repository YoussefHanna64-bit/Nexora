import 'package:nexora/core/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });
}

class CartModel {
  final List<CartItemModel> items;
  final double totalPrice;

  CartModel({
    required this.items,
    required this.totalPrice,
  });
}

final CartModel dummyCart = CartModel(
  items: [
    CartItemModel(product: dummyProducts[0], quantity: 1),
    CartItemModel(product: dummyProducts[1], quantity: 2),
    CartItemModel(product: dummyProducts[2], quantity: 1),
    CartItemModel(product: dummyProducts[3], quantity: 1),
  ],
  totalPrice: dummyProducts[0].price * 1 +
      dummyProducts[1].price * 2 +
      dummyProducts[2].price * 1 +
      dummyProducts[3].price * 1,
);
