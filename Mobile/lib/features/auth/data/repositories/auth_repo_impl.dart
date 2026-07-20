import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';
import 'package:nexora/features/auth/domain/usecases/params/auth_params.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> login(
      {required String email, required String password}) async {
    try {
      final response = await remoteDataSource
          .login(LoginParams(email: email, password: password));

      await SecureStorage.saveToken(response.accessToken);
      await SecureStorage.saveRefreshToken(response.refreshToken);

      return Right(response.user);
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
      final response = await remoteDataSource.register(RegisterParams(
        fullname: fullname,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      ));

      await SecureStorage.saveToken(response.accessToken);
      await SecureStorage.saveRefreshToken(response.refreshToken);

      return Right(response.user);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> googleAuth({required String idToken}) async {
    try {
      final response =
          await remoteDataSource.googleAuth(GoogleAuthParams(idToken: idToken));

      await SecureStorage.saveToken(response.accessToken);
      await SecureStorage.saveRefreshToken(response.refreshToken);

      return Right(response.user);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(ForgotPasswordParams(email: email));

      return Right(null);
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
      final resetToken = await remoteDataSource
          .verifyOTP(VerifyOTPParams(email: email, otp: otp));

      return Right(resetToken);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(
      {required String resetToken,
      required String newPassword,
      required String confirmPassword}) async {
    try {
      final tokens = await remoteDataSource.resetPassword(ResetPasswordParams(
        resetToken: resetToken,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ));

      await SecureStorage.saveToken(tokens.accessToken);
      await SecureStorage.saveRefreshToken(tokens.refreshToken);

      return Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
