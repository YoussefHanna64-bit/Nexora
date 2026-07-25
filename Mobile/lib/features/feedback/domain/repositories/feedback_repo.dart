import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/feedback/domain/entities/feedback.dart';

abstract class FeedbackRepo {
  Future<Either<Failure, void>> submitFeedback(Feedback feedback);
}
