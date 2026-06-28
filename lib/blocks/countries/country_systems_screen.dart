import 'package:flutter/material.dart';

import '../core/country_registry.dart';
import '../ui/app_colors.dart';
import 'poland/poland_systems.dart';

/// Экран систем внутри страны — тело под общей оболочкой.
class CountrySystemsScreen extends StatelessWidget {
  const CountrySystemsScreen({super.key, required this.country});

  final CountryDef country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('${country.flag} ${country.nameRu}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Платёжные системы',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.9),
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          ..._systems(context),
        ],
      ),
    );
  }

  List<Widget> _systems(BuildContext context) {
    switch (country.code) {
      case 'PL':
        return PolandSystems.buildList(context);
      default:
        return [
          _stubTile('WebView + пароли — блок countries/${country.code.toLowerCase()}/'),
        ];
    }
  }

  static Widget _stubTile(String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
    );
  }
}
