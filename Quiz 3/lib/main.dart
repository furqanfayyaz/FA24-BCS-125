// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/audio_game_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AudioGameService.instance.init();
  runApp(const ColorWaterSortApp());
}

class ColorWaterSortApp extends StatelessWidget {
  const ColorWaterSortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Water Sort Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          primary: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
