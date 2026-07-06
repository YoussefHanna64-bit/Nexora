import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/core/models/product_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';

class ApiWishlistRepoImpl implements WishlistRepo {
  final ApiService apiService;

  ApiWishlistRepoImpl(this.apiService);

  List<Product> parseWishlist(dynamic responseData) {
    List<Product> wishlist = [];
    for (var item in responseData['data']['wishlist']) {
      wishlist.add(ProductModel.fromJson(item));
    }
    return wishlist;
  }

  @override
  Future<Either<Failure, List<Product>>> getUserWishlist() async {
    try {
      final response = await apiService.get(EndPoints.wishlist);

      return Right(parseWishlist(response.data));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> toggleWishlist(
      String productId) async {
    try {
      final response =
          await apiService.post('${EndPoints.wishlist}/$productId');

      return Right(parseWishlist(response.data));
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
