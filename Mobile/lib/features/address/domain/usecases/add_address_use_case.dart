import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/domain/repositories/address_repo.dart';

class AddAddressUseCase {
  final AddressRepo addressRepo;

  AddAddressUseCase(this.addressRepo);

  Future<Either<Failure, List<ShippingAddress>>> call(ShippingAddress address) {
    return addressRepo.addAddress(address);
  }
}
