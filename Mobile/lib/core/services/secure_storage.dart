import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const storage = FlutterSecureStorage();

  static const String accessTokenKey = 'jwt_access_token';
  static const String refreshTokenKey = 'jwt_refresh_token';

  static Future<void> saveToken(String token) async {
    await storage.write(key: accessTokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: accessTokenKey);
  }

  static Future<void> deleteToken() async {
    await storage.delete(key: accessTokenKey);
  }

  static Future<void> saveRefreshToken(String token) async {
    await storage.write(key: refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return await storage.read(key: refreshTokenKey);
  }

  static Future<void> deleteRefreshToken() async {
    await storage.delete(key: refreshTokenKey);
  }

  static Future<void> clearAll() async {
    await storage.deleteAll();
  }
}
