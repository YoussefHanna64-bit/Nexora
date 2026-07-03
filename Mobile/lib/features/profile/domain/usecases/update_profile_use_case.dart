import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class UpdateProfileUseCase {
  final ProfileRepo profileRepo;

  UpdateProfileUseCase(this.profileRepo);

  Future<Either<Failure, User>> call({String? fullname, String? email}) {
    return profileRepo.updateProfile(fullname, email);
  }
}
