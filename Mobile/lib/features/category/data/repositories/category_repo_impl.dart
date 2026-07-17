import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/entities/category.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/category/data/datasources/category_remote_data_source.dart';
import 'package:nexora/features/category/domain/repositories/category_repo.dart';

class CategoryRepoImpl implements CategoryRepo {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await remoteDataSource.getCategories();

      return Right(categories);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
