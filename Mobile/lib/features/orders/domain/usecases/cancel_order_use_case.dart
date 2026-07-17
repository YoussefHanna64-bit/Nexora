import 'package:dartz/dartz.dart' hide Order;
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';

class CancelOrderUseCase {
  final OrderRepo orderRepo;

  CancelOrderUseCase(this.orderRepo);

  Future<Either<Failure, Order>> call(String orderId) async {
    return orderRepo.cancelOrder(orderId);
  }
}
