import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/product/domain/entities/product.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';

class GetUserWishlistUseCase {
  final WishlistRepo wishlistRepo;

  GetUserWishlistUseCase(this.wishlistRepo);

  Future<Either<Failure, List<Product>>> call() {
    return wishlistRepo.getUserWishlist();
  }
}
