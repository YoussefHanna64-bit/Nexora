import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/data/datasources/address_remote_data_source.dart';
import 'package:nexora/features/address/data/models/shipping_address_model.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/domain/repositories/address_repo.dart';

class AddressRepoImpl implements AddressRepo {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ShippingAddress>>> getAddresses() async {
    try {
      final addresses = await remoteDataSource.getAddresses();

      return Right(addresses);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShippingAddress>>> addAddress(
      ShippingAddress address) async {
    try {
      final addresses = await remoteDataSource
          .addAddress(ShippingAddressModel.fromEntity(address));

      return Right(addresses);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShippingAddress>>> updateAddress(
      String addrId, ShippingAddress address) async {
    try {
      final addresses = await remoteDataSource.updateAddress(
          addrId, ShippingAddressModel.fromEntity(address));

      return Right(addresses);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShippingAddress>>> removeAddress(
      String addrId) async {
    try {
      final addresses = await remoteDataSource.removeAddress(addrId);

      return Right(addresses);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
