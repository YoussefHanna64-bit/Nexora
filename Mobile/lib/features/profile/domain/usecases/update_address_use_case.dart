import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class UpdateAddressUseCase {
  final ProfileRepo profileRepo;

  UpdateAddressUseCase(this.profileRepo);

  Future<Either<Failure, List<ShippingAddress>>> call(
      {required String addrId, required ShippingAddress address}) {
    return profileRepo.updateAddress(addrId, address);
  }
}
