import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class RegisterUseCase {
  final AuthRepo authRepo;

  RegisterUseCase(this.authRepo);

  Future<Either<Failure, User>> call(
      {required String fullname,
      required String email,
      required String password,
      required String passwordConfirm}) {
    return authRepo.register(
      fullname: fullname,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );
  }
}
