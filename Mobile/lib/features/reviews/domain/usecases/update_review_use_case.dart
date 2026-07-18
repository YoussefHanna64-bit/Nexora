import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:nexora/features/reviews/domain/repositories/review_repo.dart';
import 'package:nexora/features/reviews/domain/usecases/params/review_params.dart';

class UpdateReviewUseCase {
  final ReviewRepo reviewRepo;

  UpdateReviewUseCase(this.reviewRepo);

  Future<Either<Failure, Review>> call(
      String reviewId, ReviewParams reviewParams) {
    return reviewRepo.updateReview(reviewId, reviewParams);
  }
}
