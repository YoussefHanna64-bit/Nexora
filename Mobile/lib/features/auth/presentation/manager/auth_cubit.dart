import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/features/auth/domain/usecases/login_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/register_use_case.dart';
import 'package:nexora/features/auth/presentation/manager/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit(this.loginUseCase, this.registerUseCase) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await loginUseCase(email: email, password: password);

    result.fold(
      (failure) {
        emit(AuthError(message: failure.message));
      },
      (user) {
        emit(AuthSuccess(user: user));
      },
    );
  }

  Future<void> register({
    required String fullname,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    emit(AuthLoading());

    final result = await registerUseCase(
      fullname: fullname,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );

    result.fold(
      (failure) {
        emit(AuthError(message: failure.message));
      },
      (user) {
        emit(AuthSuccess(user: user));
      },
    );
  }

  Future<void> logout() async {
    await SecureStorage.deleteToken();

    emit(AuthInitial());
  }
}
