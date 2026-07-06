import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/models/product_model.dart';

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

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
      price: json['price'] as num,
    );
  }
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

  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsList = json['cartItems'] as List? ?? [];
    List<CartItem> parsedItems =
        itemsList.map((i) => CartItem.fromJson(i)).toList();

    return Cart(
      id: json['_id'],
      items: parsedItems,
      totalPrice: json['totalCartPrice'] as num,
    );
  }
}

final Cart dummyCart = Cart(items: [
  CartItem(
    id: "1",
    product: Product.mockProducts[0],
    quantity: 1,
    price: 10,
  ),
  CartItem(
    id: "2",
    product: Product.mockProducts[0],
    quantity: 1,
    price: 10,
  ),
  CartItem(
    id: "3",
    product: Product.mockProducts[0],
    quantity: 1,
    price: 10,
  ),
], totalPrice: 0);
