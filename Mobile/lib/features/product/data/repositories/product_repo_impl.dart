import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/product/domain/repositories/product_repo.dart';

class ProductRepoImpl implements ProductRepo {
  final ApiService apiService;

  ProductRepoImpl(this.apiService);

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAllProducts(
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await apiService.get(EndPoints.products,
          queryParameters: queryParameters);

      List<Product> products = [];
      for (var item in response.data['data']['products']) {
        products.add(ProductModel.fromJson(item));
      }
      double maxPrice = response.data['maxPrice'].toDouble();

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
}
