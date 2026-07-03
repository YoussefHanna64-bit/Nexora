import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/domain/repositories/address_repo.dart';

class RemoveAddressUseCase {
  final AddressRepo addressRepo;

  RemoveAddressUseCase(this.addressRepo);

  Future<Either<Failure, List<ShippingAddress>>> call(String addrId) {
    return addressRepo.removeAddress(addrId);
  }
}
