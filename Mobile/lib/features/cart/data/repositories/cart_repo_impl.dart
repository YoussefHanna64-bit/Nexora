import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/features/cart/domain/entities/cart.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';

class CartRepoImpl implements CartRepo {
  final CartRemoteDataSource remoteDataSource;

  CartRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Cart>> getUserCart() async {
    try {
      final cart = await remoteDataSource.getUserCart();

      return Right(cart);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> addProductToCart(
      String productId, int quantity) async {
    try {
      final cart = await remoteDataSource.addProductToCart(productId, quantity);

      return Right(cart);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> updateCartItemQuantity(
      String cartItemId, int quantity) async {
    try {
      final cart =
          await remoteDataSource.updateCartItemQuantity(cartItemId, quantity);

      return Right(cart);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Cart>> removeCartItem(String cartItemId) async {
    try {
      final cart = await remoteDataSource.removeCartItem(cartItemId);

      return Right(cart);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearCart() async {
    try {
      await remoteDataSource.clearCart();

      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
