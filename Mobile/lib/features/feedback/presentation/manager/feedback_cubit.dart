import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/feedback/domain/entities/feedback.dart';
import 'package:nexora/features/feedback/domain/usecases/submit_feedback_use_case.dart';
import 'package:nexora/features/feedback/presentation/manager/feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final SubmitFeedbackUseCase submitFeedbackUseCase;

  FeedbackCubit(this.submitFeedbackUseCase) : super(FeedbackInitial());

  Future<void> submitFeedback({
    required String message,
    String type = "feedback",
  }) async {
    emit(FeedbackLoading());

    final feedback = Feedback(type: type, message: message);
    final result = await submitFeedbackUseCase(feedback);

    result.fold(
      (failure) {
        emit(FeedbackError(failure.message));
      },
      (message) {
        emit(FeedbackSuccess());
      },
    );
  }
}
