import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class RemoveAddressUseCase {
  final ProfileRepo profileRepo;

  RemoveAddressUseCase(this.profileRepo);

  Future<Either<Failure, List<ShippingAddress>>> call(String addrId) {
    return profileRepo.removeAddress(addrId);
  }
}
