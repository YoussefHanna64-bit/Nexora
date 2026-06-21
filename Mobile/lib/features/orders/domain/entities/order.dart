import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class OrderItem {
  final String productId;
  final String productName;
  final String productThumbnail;
  final int quantity;
  final num price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productThumbnail,
    required this.quantity,
    required this.price,
  });
}

class Order {
  final String id;
  final List<OrderItem> cartItems;
  final num totalOrderPrice;
  final String status;
  final String paymentMethodType;
  final bool isPaid;
  final ShippingAddress shippingAddress;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.cartItems,
    required this.totalOrderPrice,
    required this.status,
    required this.paymentMethodType,
    required this.isPaid,
    required this.shippingAddress,
    required this.createdAt,
  });
}
