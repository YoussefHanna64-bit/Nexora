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
}
