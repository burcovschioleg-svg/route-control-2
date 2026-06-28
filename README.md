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

- **`docs/ALL_CHATS.txt`** — **весь текст всех чатов в одном файле** (~1.2 MB)
- **`docs/CHAT_HISTORY.md`** — краткий смысл проекта
- **`docs/CURSOR_CHATS_SYNC.md`** — инструкция

Конец дня: `scripts/sync-chats.ps1` → `git push`  
Другой ПК: `git pull` → открыть `ALL_CHATS.txt` → в чате: «Прочитай ALL_CHATS.txt»

## Запуск

```powershell
cd C:\projects\route_control_2
flutter run
```

## GitHub

https://github.com/burcovschioleg-svg/route-control-2
