import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/category_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/home/domain/repositories/category_repo.dart';

class ApiCategoryRepoImpl implements CategoryRepo {
  final ApiService apiService;

  ApiCategoryRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final response = await apiService.get(EndPoints.categories);

      List<Category> categories = [];
      for (var item in response.data['data']['categories']) {
        categories.add(Category.fromJson(item));
      }

      return Right(categories);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
