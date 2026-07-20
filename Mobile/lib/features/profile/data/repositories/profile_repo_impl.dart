import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';
import 'package:nexora/features/profile/domain/usecases/params/profile_params.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final user = await remoteDataSource.getUserProfile();

      return Right(user);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(
      String? fullname, String? email) async {
    try {
      final user = await remoteDataSource
          .updateProfile(UpdateProfileParams(fullname: fullname, email: email));

      return Right(user);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(String currentPassword,
      String newPassword, String confirmPassword) async {
    try {
      final tokens = await remoteDataSource.updatePassword(UpdatePasswordParams(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ));

      await SecureStorage.saveToken(tokens.accessToken);
      await SecureStorage.saveRefreshToken(tokens.refreshToken);

      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> uploadProfilePicture(File image) async {
    try {
      final user = await remoteDataSource.uploadProfilePicture(image);

      return Right(user);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      await SecureStorage.clearAll();
      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
