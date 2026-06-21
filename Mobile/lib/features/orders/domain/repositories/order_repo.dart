import 'package:dartz/dartz.dart' hide Order;
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';

abstract class OrderRepo {
  Future<Either<Failure, String>> createPaymentIntent();

  Future<Either<Failure, Order>> createOrder({
    required ShippingAddress shippingAddress,
    required String paymentMethodType,
  });

  Future<Either<Failure, List<Order>>> getUserOrders();

  Future<Either<Failure, Order>> getOrderById(String orderId);

  Future<Either<Failure, Order>> cancelOrder(String orderId);
}
