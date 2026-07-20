import 'package:nexora/features/auth/data/models/user_model.dart';

class AuthResponse {
  final UserModel user;
  final String accessToken;
  final String refreshToken;

  AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json["data"]["user"]),
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
    );
  }
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) {
    return AuthTokens(
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
    );
  }
}
