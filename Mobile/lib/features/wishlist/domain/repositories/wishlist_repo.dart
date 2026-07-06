import 'package:dartz/dartz.dart';
import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/errors/failure.dart';

abstract class WishlistRepo {
  Future<Either<Failure, List<Product>>> getUserWishlist();
  Future<Either<Failure, List<Product>>> toggleWishlist(String productId);
}
