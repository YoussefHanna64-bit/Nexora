import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:nexora/core/errors/failure.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';
import 'package:nexora/features/profile/domain/repositories/profile_repo.dart';

class UploadProfilePictureUseCase {
  final ProfileRepo profileRepo;

  UploadProfilePictureUseCase(this.profileRepo);

  Future<Either<Failure, User>> call(File image) {
    return profileRepo.uploadProfilePicture(image);
  }
}
