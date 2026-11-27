// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase for Lab Assignment 2
  await Supabase.initialize(
    url: 'https://your-supabase-project.supabase.co',
    anonKey: 'your-supabase-anon-key',
  );

  runApp(const SupabaseAuthApp());
}

class SupabaseAuthApp extends StatelessWidget {
  const SupabaseAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthService.instance.currentUser != null;

    return MaterialApp(
      title: 'Supabase Authentication App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3ECF8E), // Supabase Green
          primary: const Color(0xFF3ECF8E),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}
