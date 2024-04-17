import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe/constant.dart';
import 'package:recipe/screens/MainScreen.dart';
import 'package:recipe/screens/SecondScren.dart';
import 'package:recipe/states/states.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
void main() async {
  Gemini.init(apiKey: GeminiApiKey);
  runApp(ProviderScope(child: const RecipeApp()));
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue.shade400, brightness: Brightness.dark),
      ),
      home: const MainScreen(),
    );
  }
}
