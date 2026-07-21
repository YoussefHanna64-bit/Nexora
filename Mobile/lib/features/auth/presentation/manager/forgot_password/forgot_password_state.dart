abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordEmailSent extends ForgotPasswordState {}

class ForgotPasswordOTPVerified extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {}

class ForgotPasswordError extends ForgotPasswordState {
  final String message;

  ForgotPasswordError(this.message);
}
