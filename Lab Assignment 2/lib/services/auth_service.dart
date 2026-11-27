import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService instance = AuthService._init();

  AuthService._init();

  SupabaseClient get _supabase => Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  // Sign Up with Supabase Auth
  Future<bool> signUp({required String email, required String password, required String name}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
      return response.user != null;
    } catch (e) {
      if (kDebugMode) print('Supabase Sign Up error: $e');
      return false;
    }
  }

  // Sign In with Supabase Auth
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      if (kDebugMode) print('Supabase Sign In error: $e');
      return false;
    }
  }

  // Sign Out from Supabase Auth
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      if (kDebugMode) print('Supabase Sign Out error: $e');
    }
  }
}
