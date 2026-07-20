import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/auth/data/models/auth_response.dart';
import 'package:nexora/features/auth/data/models/user_model.dart';
import 'package:nexora/features/profile/domain/usecases/params/profile_params.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateProfile(UpdateProfileParams params);
  Future<AuthTokens> updatePassword(UpdatePasswordParams params);
  Future<UserModel> uploadProfilePicture(File image);
  Future<void> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<UserModel> getUserProfile() async {
    final response = await apiService.get(EndPoints.me);
    return getUser(response.data);
  }

  @override
  Future<UserModel> updateProfile(UpdateProfileParams params) async {
    final response =
        await apiService.patch(EndPoints.updateUser, body: params.toJson());

    return getUser(response.data);
  }

  @override
  Future<AuthTokens> updatePassword(UpdatePasswordParams params) async {
    final response = await apiService.patch(
      EndPoints.updatePassword,
      body: params.toJson(),
    );
    return AuthTokens.fromJson(response.data);
  }

  @override
  Future<UserModel> uploadProfilePicture(File image) async {
    FormData formData = FormData.fromMap({
      "profileImage": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split("/").last,
      ),
    });

    final response =
        await apiService.patch(EndPoints.uploadProfilePicture, body: formData);

    return getUser(response.data);
  }

  @override
  Future<void> deleteAccount() async {
    await apiService.delete(EndPoints.users);
  }

  UserModel getUser(Map<String, dynamic> response) {
    return UserModel.fromJson(response["data"]["user"]);
  }
}
