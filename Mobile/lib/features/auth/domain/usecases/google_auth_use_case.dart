import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class GoogleAuthUseCase {
  final AuthRepo authRepo;

  GoogleAuthUseCase(this.authRepo);

  Future<Either<Failure, User>> call(String idToken) async {
    return await authRepo.googleAuth(idToken: idToken);
  }
}
