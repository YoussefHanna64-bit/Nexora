import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';

class WishlistRepoImpl implements WishlistRepo {
  final WishlistRemoteDataSource remoteDataSource;

  WishlistRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getUserWishlist() async {
    try {
      final wishlist = await remoteDataSource.getUserWishlist();

      return Right(wishlist);
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
      final wishlist = await remoteDataSource.toggleWishlist(productId);

      return Right(wishlist);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
