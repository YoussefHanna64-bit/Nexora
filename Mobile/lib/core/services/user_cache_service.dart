import 'package:nexora/features/auth/domain/entities/user.dart';

class UserCacheService {
  User? user;

  String? get userId {
    return user?.id;
  }

  void clearCache() {
    user = null;
  }
}
