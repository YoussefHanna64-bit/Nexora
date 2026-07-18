import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/reviews/domain/repositories/review_repo.dart';

class DeleteReviewUseCase {
  final ReviewRepo reviewRepo;

  DeleteReviewUseCase(this.reviewRepo);

  Future<Either<Failure, void>> call(String reviewId) {
    return reviewRepo.deleteReview(reviewId);
  }
}
