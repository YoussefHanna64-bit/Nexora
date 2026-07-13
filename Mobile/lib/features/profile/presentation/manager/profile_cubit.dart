import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/profile/domain/usecases/delete_account_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_password_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/upload_profile_picture_use_case.dart';
import 'package:nexora/features/profile/presentation/manager/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final UploadProfilePictureUseCase uploadProfilePictureUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileCubit(
      this.getUserProfileUseCase,
      this.updateProfileUseCase,
      this.updatePasswordUseCase,
      this.uploadProfilePictureUseCase,
      this.deleteAccountUseCase)
      : super(ProfileInitial());

  User? currentUser;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    final result = await getUserProfileUseCase();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (user) {
        currentUser = user;
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> updateProfile({String? fullname, String? email}) async {
    emit(ProfileUpdating());

    final result = await updateProfileUseCase(fullname: fullname, email: email);

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (user) {
        currentUser = user;
        emit(ProfileUpdateSuccess());
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    emit(ProfileUpdating());

    final result = await updatePasswordUseCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (message) {
        emit(PasswordChangeSuccess());
        if (currentUser != null) {
          emit(ProfileLoaded(currentUser!));
        }
      },
    );
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    try {
      final pickedImage = await imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedImage == null) {
        return;
      }

      emit(ProfileImageUploading());

      final imageFile = File(pickedImage.path);
      final result = await uploadProfilePictureUseCase(imageFile);

      result.fold(
        (failure) {
          emit(ProfileError(failure.message));
        },
        (user) {
          currentUser = user;
          emit(ProfileUpdateSuccess());
          emit(ProfileLoaded(user));
        },
      );
    } catch (e) {
      emit(ProfileError("profile_image_upload_error"));
    }
  }

  Future<void> deleteAccount() async {
    emit(AccountDeleting());

    final result = await deleteAccountUseCase();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (message) {
        emit(AccountDeletedSuccess());
      },
    );
  }

  void clearProfile() {
    currentUser = null;
    emit(ProfileInitial());
  }
}
