import 'package:nexora/features/auth/domain/entities/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded(this.user);
}

class ProfileActionSuccess extends ProfileState {
  final String message;

  ProfileActionSuccess(this.message);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
