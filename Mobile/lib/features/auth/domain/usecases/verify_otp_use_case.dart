import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class VerifyOTPUseCase {
  final AuthRepo authRepo;

  VerifyOTPUseCase(this.authRepo);

  Future<Either<Failure, String>> call(
      {required String email, required String otp}) {
    return authRepo.verifyOTP(email: email, otp: otp);
  }
}
