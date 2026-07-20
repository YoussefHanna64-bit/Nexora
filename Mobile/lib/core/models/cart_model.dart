import 'package:nexora/core/entities/cart.dart';
import 'package:nexora/core/models/product_model.dart';

class CartItemModel extends CartItem {
  CartItemModel({
    required super.id,
    required super.product,
    required super.quantity,
    required super.price,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json["_id"],
      product: ProductModel.fromJson(json["product"]),
      quantity: json["quantity"],
      price: json["price"] as num,
    );
  }
}

class CartModel extends Cart {
  CartModel({
    super.id,
    required super.items,
    required super.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json["cartItems"] as List? ?? [];

    return CartModel(
      id: json["_id"],
      items: itemsList.map((i) => CartItemModel.fromJson(i)).toList(),
      totalPrice: json["totalCartPrice"] as num,
    );
  }
}
