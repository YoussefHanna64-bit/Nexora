import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/auth/data/models/user_model.dart';

abstract class ProfileRemoteDataSource {
  Future<UserModel> getUserProfile();
  Future<UserModel> updateProfile({String? fullname, String? email});
  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
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
  Future<UserModel> updateProfile({String? fullname, String? email}) async {
    final Map<String, dynamic> data = {};

    if (fullname != null) {
      data["fullname"] = fullname;
    }

    if (email != null) {
      data["email"] = email;
    }

    final response = await apiService.patch(EndPoints.updateUser, body: data);

    return getUser(response.data);
  }

  @override
  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await apiService.patch(
      EndPoints.updatePassword,
      body: {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "passwordConfirm": confirmPassword,
      },
    );

    final data = response.data["data"];

    return {
      "accessToken": data["accessToken"],
      "refreshToken": data["refreshToken"]
    };
  }

  @override
  Future<UserModel> uploadProfilePicture(File image) async {
    final formData = FormData.fromMap({
      "profileImage": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split("/").last,
      ),
    });

    final response = await apiService.patch(
      EndPoints.uploadProfilePicture,
      body: formData,
    );
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
