import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/wishlist/domain/repositories/wishlist_repo.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final WishlistRepo wishlistRepo;

  WishlistCubit(this.wishlistRepo) : super(WishlistInitial());

  bool isInWishlist(String productId) {
    if (state is WishlistSuccess) {
      return (state as WishlistSuccess)
          .wishlist
          .any((item) => item.id == productId);
    }
    return false;
  }

  Future<void> fetchWishlist() async {
    emit(WishlistLoading());

    final result = await wishlistRepo.getUserWishlist();

    result.fold(
      (failure) {
        emit(WishlistError(message: failure.message));
      },
      (wishlist) {
        emit(WishlistSuccess(wishlist: wishlist));
      },
    );
  }

  Future<void> toggleItem(String productId) async {
    final result = await wishlistRepo.toggleWishlist(productId);

    result.fold(
      (failure) {
        emit(WishlistError(message: failure.message));
      },
      (wishlist) {
        emit(WishlistSuccess(wishlist: wishlist));
      },
    );
  }

  void clearWishlist() {
    emit(WishlistInitial());
  }
}
