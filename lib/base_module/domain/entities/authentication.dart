import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



class Authentication {
  static final _instance = Authentication._internal();
  factory Authentication() => _instance;
  Authentication._internal();

  static const _keyAuthUser = 'authenticated_user';
  
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // LoginModel? _authenticatedUser;

  // LoginModel? get authenticatedUser => _authenticatedUser;
  // bool get isAuthenticated => _authenticatedUser?.accessToken?.isNotEmpty ?? false;
  // UserModel? get user => _authenticatedUser?.user;
  // String get token => _authenticatedUser?.accessToken ?? '';
  // String get refreshToken => _authenticatedUser?.refreshToken ?? '';

  // Future<void> init() async {
  //   try {
  //     final jsonString = await _storage.read(key: _keyAuthUser);
  //     if (jsonString == null) return;

  //     _authenticatedUser = LoginModel.fromJson(
  //       jsonDecode(jsonString) as Map<String, dynamic>,
  //     );
  //     debugPrint('Authentication initialized successfully');
  //   } catch (e) {
  //     debugPrint('Authentication:init:Error: $e');
  //     await clear(); 
  //   }
  // }

  // Future<bool> save(LoginModel user) async {
  //   try {
  //     _authenticatedUser = user;
  //     await _storage.write(
  //       key: _keyAuthUser,
  //       value: jsonEncode(user.toJson()),
  //     );
  //     debugPrint('User saved successfully');
  //     return true;
  //   } catch (e) {
  //     debugPrint('Authentication:save:Error: $e');
  //     return false;
  //   }
  // }

  // Future<bool> clear() async {
  //   try {
  //     _authenticatedUser = null;
  //     await _storage.delete(key: _keyAuthUser);
  //     debugPrint('User cleared successfully');
  //     return true;
  //   } catch (e) {
  //     debugPrint('Authentication:clear:Error: $e');
  //     return false;
  //   }
  // }

  // Future<bool> updateUser({required LoginModel user}) async {
  //   if (_authenticatedUser == null) return false;
    
  //   final updated = LoginModel(
  //     user: user.user ,
  //     accessToken: _authenticatedUser!.accessToken,
  //     refreshToken: _authenticatedUser!.refreshToken
  //   );
  //   return save(updated);
  // }

  Future<bool> hasStoredCredentials() async {
    try {
      final data = await _storage.read(key: _keyAuthUser);
      return data != null;
    } catch (e) {
      return false;
    }
  }
}

final authentication = Authentication();