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
  ],
  totalPrice: 0
);
