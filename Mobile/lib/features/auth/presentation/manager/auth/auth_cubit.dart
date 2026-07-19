import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nexora/core/constants/api_keys.dart';
import 'package:nexora/core/services/secure_storage.dart';
import 'package:nexora/core/services/user_cache_service.dart';
import 'package:nexora/features/auth/domain/usecases/google_auth_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/login_use_case.dart';
import 'package:nexora/features/auth/domain/usecases/register_use_case.dart';
import 'package:nexora/features/auth/presentation/manager/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GoogleAuthUseCase googleAuthUseCase;
  final UserCacheService userCacheService;

  AuthCubit(
    this.loginUseCase,
    this.registerUseCase,
    this.googleAuthUseCase,
    this.userCacheService,
  ) : super(AuthInitial());

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await loginUseCase(email: email, password: password);

    result.fold(
      (failure) {
        emit(AuthError(message: failure.message));
      },
      (user) {
        userCacheService.user = user;
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
        userCacheService.user = user;
        emit(AuthSuccess(user: user));
      },
    );
  }

  Future<void> googleAuth() async {
    emit(AuthLoading());

    try {
      await _googleSignIn.initialize(serverClientId: ApiKeys.googleClientId);

      final GoogleSignInAccount user = await _googleSignIn.authenticate();

      final String? idToken = user.authentication.idToken;

      if (idToken == null) {
        emit(AuthError(message: "google_auth_failed"));
        return;
      }

      final result = await googleAuthUseCase(idToken);

      result.fold(
        (failure) {
          _googleSignIn.signOut();
          emit(AuthError(message: failure.message));
        },
        (user) {
          userCacheService.user = user;
          emit(AuthSuccess(user: user));
        },
      );
    } catch (e) {
      _googleSignIn.signOut();
      emit(AuthError(message: "google_auth_failed"));
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    userCacheService.clearCache();
    emit(AuthInitial());
  }
}
