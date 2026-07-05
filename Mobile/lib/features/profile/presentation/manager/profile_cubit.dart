import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/profile/domain/usecases/delete_account_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/get_user_profile_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_password_use_case.dart';
import 'package:nexora/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:nexora/features/profile/presentation/manager/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;

  ProfileCubit(this.getUserProfileUseCase, this.updateProfileUseCase,
      this.updatePasswordUseCase, this.deleteAccountUseCase)
      : super(ProfileInitial());

  User? currentUser;

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
