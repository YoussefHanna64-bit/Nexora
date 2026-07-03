import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class DeleteAccountUseCase {
  final ProfileRepo profileRepo;

  DeleteAccountUseCase(this.profileRepo);

  Future<Either<Failure, String>> call() {
    return profileRepo.deleteAccount();
  }
}
