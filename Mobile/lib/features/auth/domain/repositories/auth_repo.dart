import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';

abstract class AuthRepo {
  Future<Either<Failure, User>> login(
      {required String email, required String password});

  Future<Either<Failure, User>> register(
      {required String fullname,
      required String email,
      required String password,
      required String passwordConfirm});

  Future<Either<Failure, User>> googleAuth({required String idToken});

  Future<Either<Failure, String>> forgotPassword({required String email});

  Future<Either<Failure, String>> verifyOTP(
      {required String email, required String otp});

  Future<Either<Failure, String>> resetPassword(
      {required String resetToken,
      required String newPassword,
      required String confirmPassword});
}
