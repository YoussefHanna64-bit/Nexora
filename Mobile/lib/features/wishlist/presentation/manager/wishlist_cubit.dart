import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/wishlist/domain/usecases/get_user_wishlist_use_case.dart';
import 'package:nexora/features/wishlist/domain/usecases/toggle_wishlist_use_case.dart';
import 'package:nexora/features/wishlist/presentation/manager/wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  final GetUserWishlistUseCase getUserWishlistUseCase;
  final ToggleWishlistUseCase toggleWishlistUseCase;

  WishlistCubit(this.getUserWishlistUseCase, this.toggleWishlistUseCase)
      : super(WishlistInitial());

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

    final result = await getUserWishlistUseCase();

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
    final result = await toggleWishlistUseCase(productId);

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
