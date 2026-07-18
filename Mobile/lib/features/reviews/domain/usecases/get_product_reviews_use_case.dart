import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:nexora/features/reviews/domain/repositories/review_repo.dart';

class GetProductReviewsUseCase {
  final ReviewRepo reviewRepo;

  GetProductReviewsUseCase(this.reviewRepo);

  Future<Either<Failure, List<Review>>> call(String productId) {
    return reviewRepo.getProductReviews(productId);
  }
}
