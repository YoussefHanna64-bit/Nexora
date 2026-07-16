import 'package:dartz/dartz.dart';
import 'package:nexora/core/entities/cart.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';

class RemoveCartItemUseCase {
  final CartRepo cartRepo;

  RemoveCartItemUseCase(this.cartRepo);

  Future<Either<Failure, Cart>> call(String cartItemId) {
    return cartRepo.removeCartItem(cartItemId);
  }
}
