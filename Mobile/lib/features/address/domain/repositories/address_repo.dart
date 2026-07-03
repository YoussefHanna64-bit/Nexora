import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';

abstract class AddressRepo {
  Future<Either<Failure, List<ShippingAddress>>> addAddress(
      ShippingAddress address);
  Future<Either<Failure, List<ShippingAddress>>> updateAddress(
      String addrId, ShippingAddress address);
  Future<Either<Failure, List<ShippingAddress>>> removeAddress(String addrId);
}
