import 'package:dartz/dartz.dart';
import 'package:nexora/features/cart/domain/entities/cart.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';

class GetUserCartUseCase {
  final CartRepo cartRepo;

  GetUserCartUseCase(this.cartRepo);

  Future<Either<Failure, Cart>> call() {
    return cartRepo.getUserCart();
  }
}
