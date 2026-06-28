import 'package:flutter/material.dart';

import '../core/country_registry.dart';
import '../countries/country_systems_screen.dart';
import '../countries/country_tile.dart';
import '../ui/app_colors.dart';
import 'app_drawer.dart';

/// Главная — оболочка. Секции и страны подключаются как модули.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final countries = CountryRegistry.enabled();

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Route Control 2'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                'v2 · shell',
                style: TextStyle(
                  color: AppColors.accent.withValues(alpha: 0.8),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          _sectionTitle('Платёжные системы'),
          const SizedBox(height: 8),
          ...countries.map(
            (c) => CountryTile(
              country: c,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CountrySystemsScreen(country: c),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _sectionTitle('Скоро'),
          const SizedBox(height: 8),
          _placeholderSection('GPS / трекинг', 'blocks/gps/'),
          _placeholderSection('Запреты для грузовиков', 'blocks/trafficban/'),
          _placeholderSection('Фирмы и профили', 'blocks/firms/'),
          _placeholderSection('Настройки', 'blocks/settings/'),
        ],
      ),
    );
  }

  static Widget _sectionTitle(String t) {
    return Text(
      t.toUpperCase(),
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Widget _placeholderSection(String title, String path) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  path,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.hourglass_empty, color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }
}
