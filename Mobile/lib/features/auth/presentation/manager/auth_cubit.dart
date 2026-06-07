import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/auth/domain/repositories/auth_repo.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;

  AuthCubit(this.authRepo) : super(AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final response = await authRepo.login(email: email, password: password);

    response.fold(
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

    final response = await authRepo.register(
      fullname: fullname,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );

    response.fold(
      (failure) {
        emit(AuthError(message: failure.message));
      },
      (user) {
        emit(AuthSuccess(user: user));
      },
    );
  }
}
