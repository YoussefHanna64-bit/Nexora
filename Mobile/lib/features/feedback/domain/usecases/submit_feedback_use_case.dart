import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/feedback/domain/entities/feedback.dart';
import 'package:nexora/features/feedback/domain/repositories/feedback_repo.dart';

class SubmitFeedbackUseCase {
  final FeedbackRepo feedbackRepo;

  SubmitFeedbackUseCase(this.feedbackRepo);

  Future<Either<Failure, void>> call(Feedback feedback) {
    return feedbackRepo.submitFeedback(feedback);
  }
}
