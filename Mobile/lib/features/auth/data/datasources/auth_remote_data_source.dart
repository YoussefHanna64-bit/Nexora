import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/auth/data/models/auth_response.dart';
import 'package:nexora/features/auth/domain/usecases/params/auth_params.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(LoginParams params);
  Future<AuthResponse> register(RegisterParams params);
  Future<AuthResponse> googleAuth(GoogleAuthParams params);
  Future<void> forgotPassword(ForgotPasswordParams params);
  Future<String> verifyOTP(VerifyOTPParams params);
  Future<AuthTokens> resetPassword(ResetPasswordParams params);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<AuthResponse> login(LoginParams params) async {
    final response =
        await apiService.post(EndPoints.login, body: params.toJson());

    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<AuthResponse> register(RegisterParams params) async {
    final response =
        await apiService.post(EndPoints.register, body: params.toJson());

    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<AuthResponse> googleAuth(GoogleAuthParams params) async {
    final response =
        await apiService.post(EndPoints.googleAuth, body: params.toJson());
    return AuthResponse.fromJson(response.data);
  }

  @override
  Future<void> forgotPassword(ForgotPasswordParams params) async {
    await apiService.post(EndPoints.forgotPassword, body: params.toJson());
  }

  @override
  Future<String> verifyOTP(VerifyOTPParams params) async {
    final response =
        await apiService.post(EndPoints.verifyOTP, body: params.toJson());

    return response.data["resetToken"];
  }

  @override
  Future<AuthTokens> resetPassword(ResetPasswordParams params) async {
    final response =
        await apiService.patch(EndPoints.resetPassword, body: params.toJson());

    return AuthTokens.fromJson(response.data);
  }
}
