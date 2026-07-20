import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/verify_otp_use_case.dart';
import 'package:nexora/features/auth/presentation/manager/forgot_password/forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPasswordCubit({
    required this.forgotPasswordUseCase,
    required this.verifyOTPUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPasswordInitial());

  String? _email;
  String? _resetToken;

  Future<void> forgotPassword(String email) async {
    emit(ForgotPasswordLoading());

    final result = await forgotPasswordUseCase(email: email);

    result.fold(
      (failure) {
        emit(ForgotPasswordError(failure.message));
      },
      (message) {
        _email = email;
        emit(ForgotPasswordEmailSent("account_email_sent"));
      },
    );
  }

  Future<void> verifyOTP(String otp) async {
    emit(ForgotPasswordLoading());

    final result = await verifyOTPUseCase(email: _email!, otp: otp);

    result.fold(
      (failure) {
        emit(ForgotPasswordError(failure.message));
      },
      (resetToken) {
        _resetToken = resetToken;
        emit(ForgotPasswordOTPVerified());
      },
    );
  }

  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ForgotPasswordLoading());

    final result = await resetPasswordUseCase(
      resetToken: _resetToken!,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) {
        emit(ForgotPasswordError(failure.message));
      },
      (message) {
        _email = null;
        _resetToken = null;

        emit(ForgotPasswordSuccess("account_recovered"));
      },
    );
  }
}
