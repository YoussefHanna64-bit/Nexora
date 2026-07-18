import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/reviews/domain/entities/review.dart';
import 'package:nexora/features/reviews/domain/repositories/review_repo.dart';
import 'package:nexora/features/reviews/domain/usecases/params/review_params.dart';

class AddReviewUseCase {
  final ReviewRepo reviewRepo;

  AddReviewUseCase(this.reviewRepo);

  Future<Either<Failure, Review>> call(ReviewParams reviewParams) {
    return reviewRepo.addReview(reviewParams);
  }
}
