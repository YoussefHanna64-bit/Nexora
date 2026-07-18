import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:nexora/features/reviews/domain/usecases/add_review_use_case.dart';
import 'package:nexora/features/reviews/domain/usecases/delete_review_use_case.dart';
import 'package:nexora/features/reviews/domain/usecases/get_product_reviews_use_case.dart';
import 'package:nexora/features/reviews/domain/usecases/params/review_params.dart';
import 'package:nexora/features/reviews/domain/usecases/update_review_use_case.dart';
import 'package:nexora/features/reviews/presentation/manager/review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final GetProductReviewsUseCase getProductReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;

  ReviewCubit(this.getProductReviewsUseCase, this.addReviewUseCase,
      this.updateReviewUseCase, this.deleteReviewUseCase)
      : super(ReviewInitial());

  List<Review> _currentReviews = [];

  Future<void> fetchProductReviews(String productId) async {
    emit(ReviewLoading());
    final result = await getProductReviewsUseCase(productId);

    result.fold(
      (failure) {
        emit(ReviewError(failure.message));
      },
      (reviews) {
        _currentReviews = reviews;
        emit(ReviewLoaded(reviews));
      },
    );
  }

  Future<void> submitReview(ReviewParams reviewParams) async {
    emit(ReviewLoading());
    final result = await addReviewUseCase(reviewParams);

    result.fold(
      (failure) {
        emit(ReviewError(failure.message));
      },
      (review) {
        _currentReviews.insert(0, review);
        emit(ReviewActionSuccess("thank_you_for_your_review"));
        emit(ReviewLoaded(_currentReviews));
      },
    );
  }

  Future<void> editReview(String reviewId, ReviewParams reviewParams) async {
    emit(ReviewLoading());
    final result = await updateReviewUseCase(reviewId, reviewParams);

    result.fold(
      (failure) {
        emit(ReviewError(failure.message));
      },
      (review) {
        final index = _currentReviews.indexWhere((r) => r.id == review.id);

        if (index != -1) {
          _currentReviews[index] = review;
        }

        emit(ReviewActionSuccess("review_updated"));
        emit(ReviewLoaded(_currentReviews));
      },
    );
  }

  Future<void> removeReview(String reviewId) async {
    emit(ReviewLoading());
    final result = await deleteReviewUseCase(reviewId);

    result.fold(
      (failure) {
        emit(ReviewError(failure.message));
      },
      (message) {
        _currentReviews.removeWhere((review) => review.id == reviewId);
        emit(ReviewActionSuccess("review_deleted"));
        emit(ReviewLoaded(_currentReviews));
      },
    );
  }
}
