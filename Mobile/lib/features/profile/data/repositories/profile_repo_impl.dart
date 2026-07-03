import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/auth/data/models/user_model.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
      final json = await remoteDataSource.getUserProfile();

      return Right(UserModel.fromJson(json["data"]["user"]));
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
      final Map<String, dynamic> data = {};

      if (fullname != null) {
        data["fullname"] = fullname;
      }

      if (email != null) {
        data["email"] = email;
      }

      final json = await remoteDataSource.updateProfile(data);

      return Right(UserModel.fromJson(json["data"]["user"]));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> updatePassword(String currentPassword,
      String newPassword, String confirmPassword) async {
    try {
      final json = await remoteDataSource.updatePassword({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "passwordConfirm": confirmPassword,
      });

      final newToken = json["token"];
      await SecureStorage.saveToken(newToken);

      return Right(json["message"]);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAccount() async {
    try {
      final json = await remoteDataSource.deleteAccount();

      await SecureStorage.deleteToken();

      return Right(json["message"]);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
