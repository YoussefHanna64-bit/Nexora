import 'package:dartz/dartz.dart';
import 'package:nexora/features/cart/domain/entities/cart.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';

class AddProductToCartUseCase {
  final CartRepo cartRepo;

  AddProductToCartUseCase(this.cartRepo);

  Future<Either<Failure, Cart>> call(String productId, int quantity) {
    return cartRepo.addProductToCart(productId, quantity);
  }
}
