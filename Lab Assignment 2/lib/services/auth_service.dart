import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class AuthService {
  static final AuthService instance = AuthService._init();
  static const String _sessionFile = 'auth_session.json';
  static const String _usersFile = 'registered_users.json';

  UserModel? _currentUser;

  AuthService._init();

  UserModel? get currentUser => _currentUser;

  Future<File> _getSessionFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_sessionFile');
  }

  Future<File> _getUsersFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_usersFile');
  }

  Future<void> initAuth() async {
    try {
      final file = await _getSessionFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final map = jsonDecode(content);
          _currentUser = UserModel.fromMap(Map<String, dynamic>.from(map));
        }
      }
    } catch (e) {
      if (kDebugMode) print('Auth init error: $e');
    }
  }

  Future<bool> signUp({required String email, required String password, required String name}) async {
    try {
      final usersFile = await _getUsersFile();
      List<dynamic> usersList = [];
      if (await usersFile.exists()) {
        final content = await usersFile.readAsString();
        if (content.trim().isNotEmpty) {
          usersList = jsonDecode(content);
        }
      }

      // Check if email exists
      if (usersList.any((u) => u['email'] == email)) {
        return false; // Email already registered
      }

      final newUser = UserModel(
        uid: 'USER-${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        displayName: name,
        createdAt: DateTime.now().toString().substring(0, 10),
      );

      usersList.add({...newUser.toMap(), 'password': password});
      await usersFile.writeAsString(jsonEncode(usersList));

      // Auto login
      _currentUser = newUser;
      final sessionFile = await _getSessionFile();
      await sessionFile.writeAsString(jsonEncode(newUser.toMap()));

      return true;
    } catch (e) {
      if (kDebugMode) print('Sign up error: $e');
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      final usersFile = await _getUsersFile();
      if (!await usersFile.exists()) return false;

      final content = await usersFile.readAsString();
      if (content.trim().isEmpty) return false;

      final List<dynamic> usersList = jsonDecode(content);
      final found = usersList.firstWhere(
        (u) => u['email'] == email && u['password'] == password,
        orElse: () => null,
      );

      if (found != null) {
        final user = UserModel(
          uid: found['uid'],
          email: found['email'],
          displayName: found['displayName'],
          createdAt: found['createdAt'],
        );
        _currentUser = user;
        final sessionFile = await _getSessionFile();
        await sessionFile.writeAsString(jsonEncode(user.toMap()));
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) print('Sign in error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    _currentUser = null;
    try {
      final file = await _getSessionFile();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      if (kDebugMode) print('Sign out error: $e');
    }
  }
}
