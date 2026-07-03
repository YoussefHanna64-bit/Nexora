import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/profile/domain/usecases/delete_account_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_password_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:nexora/features/profile/presentation/manager/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileCubit(this.getUserProfileUseCase, this.updateProfileUseCase,
      this.updatePasswordUseCase, this.deleteAccountUseCase)
      : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    final result = await getUserProfileUseCase();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (user) {
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> updateProfile({String? fullname, String? email}) async {
    emit(ProfileLoading());

    final result = await updateProfileUseCase(fullname: fullname, email: email);

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (user) {
        emit(ProfileLoaded(user));
      },
    );
  }

  Future<void> changePassword(String currentPassword, String newPassword,
      String confirmPassword) async {
    emit(ProfileLoading());

    final result = await updatePasswordUseCase(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (message) {
        emit(ProfileActionSuccess(message));
      },
    );
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoading());

    final result = await deleteAccountUseCase();

    result.fold(
      (failure) {
        emit(ProfileError(failure.message));
      },
      (message) {
        emit(ProfileActionSuccess(message));
      },
    );
  }
}
