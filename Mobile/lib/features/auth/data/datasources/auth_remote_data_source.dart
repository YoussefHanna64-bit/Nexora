import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
      String fullname, String email, String password, String passwordConfirm);
  Future<Map<String, dynamic>> googleAuth(String idToken);
  Future<Map<String, dynamic>> forgotPassword(String email);
  Future<Map<String, dynamic>> verifyOTP(String email, String otp);
  Future<Map<String, dynamic>> resetPassword(
      String resetToken, String newPassword, String confirmPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiService.post(
      EndPoints.login,
      body: {
        "email": email,
        "password": password,
      },
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> register(String fullname, String email,
      String password, String passwordConfirm) async {
    final response = await apiService.post(
      EndPoints.register,
      body: {
        "fullname": fullname,
        "email": email,
        "password": password,
        "passwordConfirm": passwordConfirm
      },
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> googleAuth(String idToken) async {
    final response = await apiService.post(
      EndPoints.googleAuth,
      body: {"idToken": idToken},
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    final response = await apiService.post(
      EndPoints.forgotPassword,
      body: {
        "email": email,
      },
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    final response = await apiService.post(
      EndPoints.verifyOTP,
      body: {
        "email": email,
        "otp": otp,
      },
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
      String resetToken, String newPassword, String confirmPassword) async {
    final response = await apiService.patch(
      EndPoints.resetPassword,
      body: {
        "resetToken": resetToken,
        "newPassword": newPassword,
        "passwordConfirm": confirmPassword,
      },
    );
    return response.data;
  }
}
