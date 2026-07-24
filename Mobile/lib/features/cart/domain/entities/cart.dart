import 'package:nexora/core/entities/product.dart';

class CartItem {
  final String id;
  final Product product;
  int quantity;
  final num price;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
  });
}

class Cart {
  final String? id;
  final List<CartItem> items;
  final num totalPrice;

  Cart({
    this.id,
    required this.items,
    required this.totalPrice,
  });
}
