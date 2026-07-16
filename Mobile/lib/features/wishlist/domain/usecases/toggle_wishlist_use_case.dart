import 'package:dartz/dartz.dart';
import 'package:nexora/core/entities/product.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';

class ToggleWishlistUseCase {
  final WishlistRepo wishlistRepo;

  ToggleWishlistUseCase(this.wishlistRepo);

  Future<Either<Failure, List<Product>>> call(String productId) {
    return wishlistRepo.toggleWishlist(productId);
  }
}
