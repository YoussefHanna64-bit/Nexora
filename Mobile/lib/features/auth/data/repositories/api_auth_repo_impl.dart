import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';

class ApiAuthRepoImpl implements AuthRepo {
  final ApiService apiService;

  ApiAuthRepoImpl(this.apiService);

  @override
  Future<Either<Failure, Map<String, dynamic>>> login(
      {required String email, required String password}) async {
    try {
      final response = await apiService.post(
        EndPoints.login,
        body: {
          "email": email,
          "password": password,
        },
      );

      final token = response.data['token'];
      await SecureStorage.saveToken(token);

      return Right(response.data['data']['user']);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> register(
      {required String fullname,
      required String email,
      required String password,
      required String passwordConfirm}) async {
    try {
      final response = await apiService.post(
        EndPoints.register,
        body: {
          "fullname": fullname,
          "email": email,
          "password": password,
          "passwordConfirm": passwordConfirm
        },
      );

      final token = response.data['token'];
      await SecureStorage.saveToken(token);

      return Right(response.data['data']['user']);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
