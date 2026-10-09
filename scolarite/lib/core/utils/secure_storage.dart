
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class SecureStorage {
  // Android options
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  // Web options
  WebOptions _getWebOptions() =>
      const WebOptions(dbName: 'admin_app', publicKey: 'admin_public_key');

  // Instance of FlutterSecureStorage
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Keys
  static const String _accesstoken = "access_auth_token";
  static const String _refreshtoken = "refresh_auth_token";
  static const String _authtoken = "auth_token";

  /// Save token
  Future<void> setAccessToken(String? token) async {
    await _storage.write(
      key: _accesstoken,
      value: token ?? "",
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  Future<void> setRefreshToken(String? token) async {
    await _storage.write(
      key: _refreshtoken,
      value: token ?? "",
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  Future<void> setauthtoken(String? token) async {
    await _storage.write(
      key: _authtoken,
      value: token ?? "",
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  /// Get token
  Future<String?> getaccessToken() async {
    return await _storage.read(
      key: _accesstoken,
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  Future<String?> getauthtoken() async {
    return await _storage.read(
      key: _authtoken,
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  Future<String?> getrefreshToken() async {
    return await _storage.read(
      key: _refreshtoken,
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  /// Remove token
  Future<void> removeaccessToken() async {
    await _storage.delete(
      key: _accesstoken,
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  Future<void> removeauthtoken() async {
    await _storage.delete(
      key: _authtoken,
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }

  Future<void> removerefreshToken() async {
    await _storage.delete(
      key: _refreshtoken,
      aOptions: _getAndroidOptions(),
      webOptions: _getWebOptions(),
    );
  }
}
