import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/product/domain/entities/product.dart';

abstract class WishlistRepo {
  Future<Either<Failure, List<Product>>> getUserWishlist();
  Future<Either<Failure, List<Product>>> toggleWishlist(String productId);
}
