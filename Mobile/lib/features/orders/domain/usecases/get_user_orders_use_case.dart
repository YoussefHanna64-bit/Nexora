import 'package:dartz/dartz.dart' hide Order;
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';

class GetUserOrdersUseCase {
  final OrderRepo orderRepo;

  GetUserOrdersUseCase(this.orderRepo);

  Future<Either<Failure, List<Order>>> call() async {
    return orderRepo.getUserOrders();
  }
}
