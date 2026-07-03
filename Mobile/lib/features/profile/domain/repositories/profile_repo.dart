import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';

abstract class ProfileRepo {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> updateProfile(String? fullname, String? email);
  Future<Either<Failure, String>> updatePassword(
      String currentPassword, String newPassword, String confirmPassword);
  Future<Either<Failure, String>> deleteAccount();

  Future<Either<Failure, List<ShippingAddress>>> addAddress(
      ShippingAddress address);
  Future<Either<Failure, List<ShippingAddress>>> updateAddress(
      String addrId, ShippingAddress address);
  Future<Either<Failure, List<ShippingAddress>>> removeAddress(String addrId);
}
