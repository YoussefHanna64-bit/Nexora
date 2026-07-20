import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class ResetPasswordUseCase {
  final AuthRepo authRepo;

  ResetPasswordUseCase(this.authRepo);

  Future<Either<Failure, void>> call(
      {required String resetToken,
      required String newPassword,
      required String confirmPassword}) {
    return authRepo.resetPassword(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
  }
}
