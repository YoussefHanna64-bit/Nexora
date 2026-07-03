import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class AddAddressUseCase {
  final ProfileRepo profileRepo;

  AddAddressUseCase(this.profileRepo);

  Future<Either<Failure, List<ShippingAddress>>> call(ShippingAddress address) {
    return profileRepo.addAddress(address);
  }
}
