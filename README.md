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

## История чатов (синхрон между ПК)

- **`docs/CHAT_HISTORY.md`** — смысл проекта.
- **`docs/cursor-sessions/`** — полные чаты (`.md` читать глазами, агент читает всё).
- **`docs/CURSOR_CHATS_SYNC.md`** — инструкция ПК ↔ Git.

Конец дня: `scripts/sync-chats.ps1` → `git push`.  
Другой ПК: `git pull` → `scripts/sync-chats.ps1`.

## Запуск

```powershell
cd C:\projects\route_control_2
flutter run
```

## GitHub

https://github.com/burcovschioleg-svg/route-control-2
