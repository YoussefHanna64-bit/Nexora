class UpdateProfileParams {
  final String? fullname;
  final String? email;

  UpdateProfileParams({this.fullname, this.email});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (fullname != null) {
      data["fullname"] = fullname;
    }

    if (email != null) {
      data["email"] = email;
    }

    return data;
  }
}

class UpdatePasswordParams {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;

  UpdatePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      "currentPassword": currentPassword,
      "newPassword": newPassword,
      "passwordConfirm": confirmPassword,
    };
  }
}
