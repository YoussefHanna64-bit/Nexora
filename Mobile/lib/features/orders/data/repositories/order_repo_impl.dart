import 'package:dartz/dartz.dart' hide Order;
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/data/models/shipping_address_model.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/orders/data/datasources/order_remote_data_source.dart';
import 'package:nexora/features/orders/domain/entities/order.dart';
import 'package:nexora/features/orders/domain/repositories/order_repo.dart';

class OrderRepoImpl implements OrderRepo {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, String>> createPaymentIntent() async {
    try {
      final clientSecret = await remoteDataSource.createPaymentIntent();
      return Right(clientSecret);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> createOrder({
    required ShippingAddress shippingAddress,
    required String paymentMethodType,
  }) async {
    try {
      final address = ShippingAddressModel.fromEntity(shippingAddress).toJson();

      final order = await remoteDataSource.createOrder(
        address,
        paymentMethodType,
      );

      return Right(order);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getUserOrders() async {
    try {
      final orders = await remoteDataSource.getUserOrders();
      return Right(orders);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(String orderId) async {
    try {
      final order = await remoteDataSource.getOrderById(orderId);
      return Right(order);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> cancelOrder(String orderId) async {
    try {
      final order = await remoteDataSource.cancelOrder(orderId);
      return Right(order);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
