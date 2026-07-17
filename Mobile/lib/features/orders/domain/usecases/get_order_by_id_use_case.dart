import 'package:dartz/dartz.dart' hide Order;
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';

class GetOrderByIdUseCase {
  final OrderRepo orderRepo;

  GetOrderByIdUseCase(this.orderRepo);

  Future<Either<Failure, Order>> call(String orderId) {
    return orderRepo.getOrderById(orderId);
  }
}
