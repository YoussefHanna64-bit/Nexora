import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/feedback/data/models/feedback_model.dart';

abstract class FeedbackRemoteDataSource {
  Future<void> submitFeedback(FeedbackModel model);
}

class FeedbackRemoteDataSourceImpl implements FeedbackRemoteDataSource {
  final ApiService apiService;

  FeedbackRemoteDataSourceImpl(this.apiService);

  @override
  Future<void> submitFeedback(FeedbackModel model) async {
    await apiService.post(
      EndPoints.feedbacks,
      body: model.toJson(),
    );
  }
}
