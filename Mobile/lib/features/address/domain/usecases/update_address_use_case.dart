import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/domain/repositories/address_repo.dart';

class UpdateAddressUseCase {
  final AddressRepo addressRepo;

  UpdateAddressUseCase(this.addressRepo);

  Future<Either<Failure, List<ShippingAddress>>> call(
      {required String addrId, required ShippingAddress address}) {
    return addressRepo.updateAddress(addrId, address);
  }
}
