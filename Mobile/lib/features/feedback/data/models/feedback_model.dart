import 'package:nexora/features/feedback/domain/entities/feedback.dart';

class FeedbackModel extends Feedback {
  FeedbackModel({
    required super.type,
    required super.message,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "message": message,
    };
  }

  factory FeedbackModel.fromEntity(Feedback feedback) {
    return FeedbackModel(
      type: feedback.type,
      message: feedback.message,
    );
  }
}
