import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';

class ApiProductRepoImpl implements ProductRepo {
  final ApiService apiService;

  ApiProductRepoImpl(this.apiService);

  @override
  Future<Either<Failure, List<Product>>> getAllProducts(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiService.get(EndPoints.products,
          queryParameters: queryParameters);

      List<Product> products = [];
      for (var item in response.data['data']['products']) {
        products.add(Product.fromJson(item));
      }

      return Right(products);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
