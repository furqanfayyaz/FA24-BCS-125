// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.initAuth();
  runApp(const FirebaseAuthApp());
}

class FirebaseAuthApp extends StatelessWidget {
  const FirebaseAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = AuthService.instance.currentUser != null;

    return MaterialApp(
      title: 'Firebase Authentication App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          primary: const Color(0xFF1976D2),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF4F6F9),
      ),
      home: isLoggedIn ? const DashboardScreen() : const LoginScreen(),
    );
  }
}
