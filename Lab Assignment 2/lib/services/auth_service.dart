import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final AuthService instance = AuthService._init();

  AuthService._init();

  SupabaseClient get _supabase => Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;

  // Sign Up with Supabase Auth returning error message if any
  Future<String?> signUp({required String email, required String password, required String name}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': name},
      );
      if (response.user != null) {
        return null; // success
      }
      return 'Registration failed. Please try again.';
    } catch (e) {
      if (kDebugMode) print('Supabase Sign Up error: $e');
      // Clean up exception message formatting
      final msg = e.toString().replaceAll('AuthException:', '').trim();
      return msg;
    }
  }

  // Sign In with Supabase Auth returning error message if any
  Future<String?> signIn({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return null; // success
      }
      return 'Invalid email or password.';
    } catch (e) {
      if (kDebugMode) print('Supabase Sign In error: $e');
      final msg = e.toString().replaceAll('AuthException:', '').trim();
      return msg;
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
