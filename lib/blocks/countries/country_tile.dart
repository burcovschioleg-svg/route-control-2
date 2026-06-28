import 'package:flutter/material.dart';

import '../core/country_registry.dart';
import '../ui/app_colors.dart';

class CountryTile extends StatelessWidget {
  const CountryTile({
    super.key,
    required this.country,
    required this.onTap,
  });

  final CountryDef country;
  final VoidCallback onTap;

  bool get _disabled => country.status == CountryStatus.comingSoon;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Opacity(
            opacity: _disabled ? 0.45 : 1,
            child: Text(country.flag, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.nameRu,
                  style: TextStyle(
                    color: _disabled
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  country.systemsHint,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                if (_disabled)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Text(
                      'В разработке',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!_disabled)
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    );

    if (_disabled) {
      return Opacity(opacity: 0.55, child: child);
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: child,
    );
  }
}
