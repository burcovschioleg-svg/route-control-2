# Route Control 2

Новая версия с **одной оболочкой** (`blocks/shell/`) и модулями под неё.

| | v1 (архив) | v2 (здесь) |
|---|------------|------------|
| Путь | `C:\projects\route_control` | `C:\projects\route_control_2` |
| Git | `route-control` → ветка `archive/v1-legacy` | [route-control-2](https://github.com/burcovschioleg-svg/route-control-2) |
| main.dart | ~18k строк | ~30 строк |

## Структура

```
lib/
  main.dart              ← только runApp
  app.dart               ← тема, MaterialApp
  blocks/
    shell/               ← ОБОЛОЧКА (главная, drawer, top bar)
    core/                ← профиль, языки, registry стран
    ui/                  ← цвета, плитки
    countries/           ← PL, HU, RO… (каждая — свой блок)
    firms/               ← (заглушка)
    settings/            ← (заглушка)
```

## Первый этап

1. Оболочка + список стран (PL/HU/RO активны, остальные «в разработке»)
2. Потом: `countries/poland/systems/etoll/` — баланс с нуля
3. Firebase / Google — те же ключи, что у v1 (отдельно в консолях)

## История чатов (другой ПК / новый агент)

- **Контекст:** `docs/PROJECT_CONTEXT.md` — кратко, с чего начать.
- **Полный лог:** `docs/CHAT_HISTORY.md` (~1 MB, все сессии Cursor).
- Обновить: `powershell -File scripts/export-chat-history.ps1`

## Запуск

```powershell
cd C:\projects\route_control_2
flutter run
```

## GitHub

https://github.com/burcovschioleg-svg/route-control-2
