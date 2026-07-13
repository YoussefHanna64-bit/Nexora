import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';

abstract class ProfileRepo {
  Future<Either<Failure, User>> getUserProfile();
  Future<Either<Failure, User>> updateProfile(String? fullname, String? email);
  Future<Either<Failure, String>> updatePassword(
      String currentPassword, String newPassword, String confirmPassword);
  Future<Either<Failure, User>> uploadProfilePicture(File image);
  Future<Either<Failure, String>> deleteAccount();
}
