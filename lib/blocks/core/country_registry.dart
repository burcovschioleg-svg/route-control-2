/// Какие страны показывать и в каком статусе (как в v1, но в одном месте).
enum CountryStatus { live, webviewOnly, comingSoon }

class CountryDef {
  final String code;
  final String flag;
  final String nameRu;
  final String systemsHint;
  final CountryStatus status;

  const CountryDef({
    required this.code,
    required this.flag,
    required this.nameRu,
    required this.systemsHint,
    required this.status,
  });
}

abstract final class CountryRegistry {
  static const all = <CountryDef>[
    CountryDef(
      code: 'PL',
      flag: '🇵🇱',
      nameRu: 'Польша',
      systemsHint: 'eTOLL · SENT/RMPD',
      status: CountryStatus.live,
    ),
    CountryDef(
      code: 'HU',
      flag: '🇭🇺',
      nameRu: 'Венгрия',
      systemsHint: 'HU-GO · BIREG',
      status: CountryStatus.webviewOnly,
    ),
    CountryDef(
      code: 'RO',
      flag: '🇷🇴',
      nameRu: 'Румыния',
      systemsHint: 'Rovinieta · CargoTrack',
      status: CountryStatus.webviewOnly,
    ),
    CountryDef(
      code: 'SK',
      flag: '🇸🇰',
      nameRu: 'Словакия',
      systemsHint: 'eMYTO',
      status: CountryStatus.comingSoon,
    ),
    CountryDef(
      code: 'CZ',
      flag: '🇨🇿',
      nameRu: 'Чехия',
      systemsHint: 'MYTO CZ',
      status: CountryStatus.comingSoon,
    ),
    CountryDef(
      code: 'SI',
      flag: '🇸🇮',
      nameRu: 'Словения',
      systemsHint: 'DarsGo',
      status: CountryStatus.comingSoon,
    ),
    CountryDef(
      code: 'DE',
      flag: '🇩🇪',
      nameRu: 'Германия',
      systemsHint: 'Toll Collect · PayToll',
      status: CountryStatus.comingSoon,
    ),
    CountryDef(
      code: 'BG',
      flag: '🇧🇬',
      nameRu: 'Болгария',
      systemsHint: 'TollPass',
      status: CountryStatus.comingSoon,
    ),
    CountryDef(
      code: 'EU',
      flag: '🇪🇺',
      nameRu: 'Балтика',
      systemsHint: 'LT · LV · EE',
      status: CountryStatus.comingSoon,
    ),
  ];

  /// Позже: читать из ProfileStore (галочки стран).
  static List<CountryDef> enabled() => all;
}
