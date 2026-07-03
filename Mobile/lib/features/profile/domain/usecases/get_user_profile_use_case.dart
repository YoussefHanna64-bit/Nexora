import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class GetUserProfileUseCase {
  final ProfileRepo profileRepo;

  GetUserProfileUseCase(this.profileRepo);

  Future<Either<Failure, User>> call() {
    return profileRepo.getUserProfile();
  }
}
