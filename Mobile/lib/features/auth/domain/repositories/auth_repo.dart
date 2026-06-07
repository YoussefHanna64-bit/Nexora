import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';

abstract class AuthRepo {
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String email, required String password});

  Future<Either<Failure, Map<String, dynamic>>> register(
      {required String fullname,
      required String email,
      required String password,
      required String passwordConfirm});
}
