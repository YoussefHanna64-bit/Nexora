import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class UpdatePasswordUseCase {
  final ProfileRepo profileRepo;

  UpdatePasswordUseCase(this.profileRepo);

  Future<Either<Failure, String>> call(
      {required String currentPassword,
      required String newPassword,
      required String confirmPassword}) {
    return profileRepo.updatePassword(
        currentPassword, newPassword, confirmPassword);
  }
}
