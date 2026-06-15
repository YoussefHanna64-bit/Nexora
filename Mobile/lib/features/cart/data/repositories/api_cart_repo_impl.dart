import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/cart_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/cart/domain/repositories/cart_repo.dart';

class ApiCartRepoImpl implements CartRepo {
  final ApiService apiService;

  ApiCartRepoImpl(this.apiService);

  @override
  Future<Either<Failure, Cart>> getUserCart() async {
    try {
      final response = await apiService.get(EndPoints.cart);

      return Right(Cart.fromJson(response.data['data']['cart']));
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
      final response = await apiService.post(EndPoints.cart,
          body: {'productId': productId, 'quantity': quantity});

      return Right(Cart.fromJson(response.data['data']['cart']));
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
      final response = await apiService
          .patch("${EndPoints.cart}/$cartItemId", body: {'quantity': quantity});

      return Right(Cart.fromJson(response.data['data']['cart']));
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
      final response = await apiService.delete("${EndPoints.cart}/$cartItemId");

      return Right(Cart.fromJson(response.data['data']['cart']));
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
      await apiService.delete(EndPoints.cart);

      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
