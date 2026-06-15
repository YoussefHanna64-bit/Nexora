import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/cart_model.dart';

abstract class CartRepo {
  Future<Either<Failure, Cart>> getUserCart();
  Future<Either<Failure, Cart>> addProductToCart(
      String productId, int quantity);
  Future<Either<Failure, Cart>> updateCartItemQuantity(
      String cartItemId, int quantity);
  Future<Either<Failure, Cart>> removeCartItem(String cartItemId);
  Future<Either<Failure, void>> clearCart();
}
