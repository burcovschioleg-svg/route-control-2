import 'package:flutter/material.dart';

import 'blocks/shell/home_screen.dart';
import 'blocks/ui/app_colors.dart';

/// Корень приложения — только тема и домашний экран оболочки.
class RouteControlApp extends StatelessWidget {
  const RouteControlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Route Control 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.dark(
          primary: AppColors.accent,
          surface: AppColors.surface,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
