import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';

class ClearCartUseCase {
  final CartRepo cartRepo;

  ClearCartUseCase(this.cartRepo);

  Future<Either<Failure, void>> call() {
    return cartRepo.clearCart();
  }
}
