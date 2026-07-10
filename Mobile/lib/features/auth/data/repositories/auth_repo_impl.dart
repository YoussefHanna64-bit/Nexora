import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nexora/features/auth/data/models/user_model.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    try {
      final json = await remoteDataSource.login(email, password);

      final accessToken = json["accessToken"];
      final refreshToken = json["refreshToken"];

      await SecureStorage.saveToken(accessToken);
      await SecureStorage.saveRefreshToken(refreshToken);

      return Right(UserModel.fromJson(json["data"]["user"]));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(
      {required String fullname,
      required String email,
      required String password,
      required String passwordConfirm}) async {
    try {
      final json = await remoteDataSource.register(
          fullname, email, password, passwordConfirm);

      final accessToken = json["accessToken"];
      final refreshToken = json["refreshToken"];

      await SecureStorage.saveToken(accessToken);
      await SecureStorage.saveRefreshToken(refreshToken);

      return Right(UserModel.fromJson(json["data"]["user"]));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(
      {required String email}) async {
    try {
      final json = await remoteDataSource.forgotPassword(email);
      return Right(json["message"]);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> verifyOTP(
      {required String email, required String otp}) async {
    try {
      final json = await remoteDataSource.verifyOTP(email, otp);
      return Right(json["resetToken"]);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword(
      {required String resetToken,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      final json = await remoteDataSource.resetPassword(
          resetToken, newPassword, confirmPassword);

      final accessToken = json["accessToken"];
      final refreshToken = json["refreshToken"];

      await SecureStorage.saveToken(accessToken);
      await SecureStorage.saveRefreshToken(refreshToken);

      return Right(json["message"]);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
