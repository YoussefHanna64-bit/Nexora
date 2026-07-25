import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/feedback/data/datasources/feedback_remote_data_source.dart';
import 'package:nexora/features/feedback/data/models/feedback_model.dart';
import 'package:nexora/features/feedback/domain/entities/feedback.dart';
import 'package:nexora/features/feedback/domain/repositories/feedback_repo.dart';

class FeedbackRepoImpl implements FeedbackRepo {
  final FeedbackRemoteDataSource remoteDataSource;

  FeedbackRepoImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> submitFeedback(Feedback feedback) async {
    try {
      await remoteDataSource.submitFeedback(FeedbackModel.fromEntity(feedback));

      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
