import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepo authRepo;

  LoginUseCase(this.authRepo);

  Future<Either<Failure, User>> call(
      {required String email, required String password}) {
    return authRepo.login(email: email, password: password);
  }
}
