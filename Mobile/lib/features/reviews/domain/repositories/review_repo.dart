import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:nexora/features/reviews/domain/usecases/params/review_params.dart';

abstract class ReviewRepo {
  Future<Either<Failure, List<Review>>> getProductReviews(String productId);
  Future<Either<Failure, Review>> addReview(ReviewParams reviewParams);
  Future<Either<Failure, Review>> updateReview(
      String reviewId, ReviewParams reviewParams);
  Future<Either<Failure, void>> deleteReview(String reviewId);
}
