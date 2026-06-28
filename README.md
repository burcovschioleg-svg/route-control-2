# Route Control 2

Новая версия с **одной оболочкой** (`blocks/shell/`) и модулями под неё.

| | v1 (архив) | v2 (здесь) |
|---|------------|------------|
| Путь | `C:\projects\route_control` | `C:\projects\route_control_2` |
| Git | `route-control` → ветка `archive/v1-legacy` | новый репо (создать на GitHub) |
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

## Запуск

```powershell
cd C:\projects\route_control_2
flutter run
```

## GitHub

`gh` на машине нет — создайте репозиторий вручную, например `route-control-2`, затем:

```powershell
cd C:\projects\route_control_2
git remote add origin https://github.com/burcovschioleg-svg/route-control-2.git
git push -u origin main
```
