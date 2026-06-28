# Route Control v2 — контекст для агента

## Контекст для агента

| Файл | Зачем |
|------|--------|
| `docs/CHAT_HISTORY.md` | Смысл проекта с нуля |
| `docs/ALL_CHATS.txt` | **Весь текст чатов** — главный для копирования |
| `docs/CURSOR_CHATS_SYNC.md` | Как синхронить ПК ↔ Git |

Синхрон чатов: `scripts/sync-chats.ps1`

**Oleg** — не программист. **Активный проект:** `route_control_2`.  
**Архив:** `route_control` (v1, не разрабатывать без просьбы).

## Быстрые ссылки

| | |
|---|---|
| v2 GitHub | https://github.com/burcovschioleg-svg/route-control-2 |
| v1 GitHub | https://github.com/burcovschioleg-svg/route-control |
| APK (после сборки) | `build/app/outputs/flutter-apk/app-debug.apk` |

## eTOLL refresh (знать наизусть)

```
login → firm → financing/list → top-up 20 PLN → PayByNet → Dalej → gateway/tecspayment → STOP
```

Карты через **top-up**, не billing/details.

## Правила

- APK — только «собери»
- Commit — только когда Oleg просит
- Код — в `blocks/`, не в `main.dart`

## Другой ПК

```powershell
git clone https://github.com/burcovschioleg-svg/route-control-2.git
```

В чате: «Прочитай docs/CHAT_HISTORY.md и docs/cursor-sessions/ — продолжай v2».

```powershell
git pull
powershell -File scripts/sync-chats.ps1
```
