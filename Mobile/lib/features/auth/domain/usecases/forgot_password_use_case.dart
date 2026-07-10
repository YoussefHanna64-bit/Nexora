import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class ForgotPasswordUseCase {
  final AuthRepo authRepo;

  ForgotPasswordUseCase(this.authRepo);

  Future<Either<Failure, String>> call({required String email}) {
    return authRepo.forgotPassword(email: email);
  }
}
