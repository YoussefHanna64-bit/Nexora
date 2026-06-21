import 'package:nexora/features/address/data/models/shipping_address_model.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel({
    required super.productId,
    required super.productName,
    required super.productThumbnail,
    required super.quantity,
    required super.price,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productData = json['product'] ?? {};

    return OrderItemModel(
      productId: productData['_id'] ?? '',
      productName: productData['name'] ?? 'Unknown Product',
      productThumbnail: productData['thumbnail'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: json['price'] ?? 0,
    );
  }
}

class OrderModel extends Order {
  OrderModel({
    required super.id,
    required super.cartItems,
    required super.totalOrderPrice,
    required super.status,
    required super.paymentMethodType,
    required super.isPaid,
    required super.shippingAddress,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['cartItems'] as List? ?? [];
    List<OrderItemModel> parsedItems =
        itemsList.map((i) => OrderItemModel.fromJson(i)).toList();

    return OrderModel(
      id: json['_id'] ?? '',
      cartItems: parsedItems,
      totalOrderPrice: json['totalOrderPrice'] ?? 0,
      status: json['status'] ?? 'pending',
      paymentMethodType: json['paymentMethodType'] ?? 'cash',
      isPaid: json['isPaid'] ?? false,
      shippingAddress:
          ShippingAddressModel.fromJson(json['shippingAddress'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
