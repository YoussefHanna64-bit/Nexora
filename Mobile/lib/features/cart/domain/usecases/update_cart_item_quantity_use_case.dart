import 'package:dartz/dartz.dart';
import 'package:nexora/core/entities/cart.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';

class UpdateCartItemQuantityUseCase {
  final CartRepo cartRepo;

  UpdateCartItemQuantityUseCase(this.cartRepo);

  Future<Either<Failure, Cart>> call(String cartItemId, int quantity) {
    return cartRepo.updateCartItemQuantity(cartItemId, quantity);
  }
}
