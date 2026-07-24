import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/product/data/datasources/product_remote_data_source.dart';
import 'package:nexora/features/product/data/models/product_model.dart';
import 'package:nexora/features/product/domain/entities/product.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllProducts(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final json = await remoteDataSource.getAllProducts(
          queryParameters: queryParameters);

      final List<Product> products = (json["data"]["products"] as List)
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();

      double maxPrice = json["maxPrice"].toDouble();

      return Right({
        'products': products,
        'maxPrice': maxPrice,
      });
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(String prodId) async {
    try {
      final json = await remoteDataSource.getProductById(prodId);

      return Right(ProductModel.fromJson(json["data"]["product"]));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
