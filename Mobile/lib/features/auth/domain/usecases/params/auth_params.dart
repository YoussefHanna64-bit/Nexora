class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}

class RegisterParams {
  final String fullname;
  final String email;
  final String password;
  final String passwordConfirm;

  RegisterParams({
    required this.fullname,
    required this.email,
    required this.password,
    required this.passwordConfirm,
  });

  Map<String, dynamic> toJson() {
    return {
      "fullname": fullname,
      "email": email,
      "password": password,
      "passwordConfirm": passwordConfirm,
    };
  }
}

class GoogleAuthParams {
  final String idToken;

  GoogleAuthParams({required this.idToken});

  Map<String, dynamic> toJson() {
    return {"idToken": idToken};
  }
}

class ForgotPasswordParams {
  final String email;

  ForgotPasswordParams({required this.email});

  Map<String, dynamic> toJson() {
    return {"email": email};
  }
}

class VerifyOTPParams {
  final String email;
  final String otp;

  VerifyOTPParams({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {"email": email, "otp": otp};
  }
}

class ResetPasswordParams {
  final String resetToken;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordParams({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "resetToken": resetToken,
      "newPassword": newPassword,
      "passwordConfirm": confirmPassword,
    };
  }
}
