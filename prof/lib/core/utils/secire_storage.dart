import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Android options (encrypted storage)
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  // Instance of FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys (to avoid typos everywhere)
  static const String _accesstoken = "access_auth_token";
  static const String _refreshtoken = "refresh_auth_token";
  static const String _authtoken = "auth_token";

  /// Save token
  Future<void> setAccessToken(String? token) async {
    await _storage.write(
      key: _accesstoken,
      value: token ?? "",
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> setRefreshToken(String? token) async {
    await _storage.write(
      key: _refreshtoken,
      value: token ?? "",
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> setauthtoken(String? token) async {
    await _storage.write(
      key: _authtoken,
      value: token ?? "",
      aOptions: _getAndroidOptions(),
    );
  }

  /// Get token
  Future<String?> getaccessToken() async {
    return await _storage.read(
      key: _accesstoken,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<String?> getauthtoken() async {
    return await _storage.read(key: _authtoken, aOptions: _getAndroidOptions());
  }

  Future<String?> getrefreshToken() async {
    return await _storage.read(
      key: _refreshtoken,
      aOptions: _getAndroidOptions(),
    );
  }

  /// Remove token
  Future<void> removeaccessToken() async {
    await _storage.delete(key: _accesstoken, aOptions: _getAndroidOptions());
  }

  Future<void> removeauthtoken() async {
    await _storage.delete(key: _authtoken, aOptions: _getAndroidOptions());
  }

  Future<void> removerefreshToken() async {
    await _storage.delete(key: _refreshtoken, aOptions: _getAndroidOptions());
  }
}
