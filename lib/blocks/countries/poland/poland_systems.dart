import 'package:flutter/material.dart';

import '../../ui/app_colors.dart';

/// Польша — первый полный блок (eTOLL, SENT). Пока заглушки.
abstract final class PolandSystems {
  static List<Widget> buildList(BuildContext context) {
    return [
      _tile(
        context,
        label: 'eTOLL',
        sub: 'Баланс · карты · пополнение',
        color: AppColors.etollRed,
        badge: 'eT',
        onTap: () => _snack(context, 'blocks/countries/poland/systems/etoll/'),
      ),
      _tile(
        context,
        label: 'SENT / PUESC',
        sub: 'Мониторинг перевозок',
        color: const Color(0xFF1565C0),
        badge: 'S',
        onTap: () => _snack(context, 'blocks/countries/poland/systems/sent/'),
      ),
    ];
  }

  static void _snack(BuildContext context, String path) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Следующий шаг: $path')),
    );
  }

  static Widget _tile(
    BuildContext context, {
    required String label,
    required String sub,
    required Color color,
    required String badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: color.withValues(alpha: 0.5)),
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    sub,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
