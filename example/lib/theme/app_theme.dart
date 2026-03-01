import 'package:flutter/material.dart';

import '../main.dart'; // We'll need to reference PasswordExample

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.system) {
        _themeMode = ThemeMode.light;
      } else if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.system;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Professional "Security & Trust" Palette (Tailwind-inspired)
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF10B981), // Emerald 500
      primary: const Color(0xFF10B981),
      secondary: const Color(0xFF3B82F6), // Blue 500
      tertiary: const Color(0xFF8B5CF6), // Violet 500 (accent)
      surface: const Color(0xFFFFFFFF), // White
      brightness: Brightness.light,
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF34D399), // Emerald 400
      primary: const Color(0xFF34D399),
      secondary: const Color(0xFF60A5FA), // Blue 400
      tertiary: const Color(0xFFA78BFA), // Violet 400
      surface: const Color(0xFF1F2937), // Gray 800
      brightness: Brightness.dark,
    );

    final baseTheme = ThemeData(
      colorScheme: lightColorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Gray 50
      fontFamily: 'Outfit',
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white.withValues(alpha: 0.8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: lightColorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
              color: lightColorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
        ),
      ),
    );

    return MaterialApp(
      title: 'Password Studio',
      theme: baseTheme,
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF111827), // Gray 900
        fontFamily: 'Outfit',
        cardTheme: CardThemeData(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          color: darkColorScheme.surface
              .withValues(alpha: 0.8), // Semi-transparent Gray 800
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkColorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: darkColorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: darkColorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
          ),
        ),
      ),
      themeMode: _themeMode,
      home: PasswordExample(
        currentThemeMode: _themeMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}
