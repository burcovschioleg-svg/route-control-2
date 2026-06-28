# Route Control — контекст проекта (для агента и другого ПК)

> Обновляй вместе с `CHAT_HISTORY.md` (скрипт `scripts/export-chat-history.ps1`).

**Кто:** Oleg, не программист.  
**Задача:** Flutter-приложение для перевозчиков — eTOLL Польша, другие страны позже.

---

## Два репозитория

| | v1 (архив / пример) | v2 (активная разработка) |
|---|---------------------|---------------------------|
| Папка | `C:\projects\route_control` | `C:\projects\route_control_2` |
| GitHub | https://github.com/burcovschioleg-svg/route-control | https://github.com/burcovschioleg-svg/route-control-2 |
| Архив v1 | ветка `archive/v1-legacy`, тег `archive/v1-legacy-2026-06-28` | — |
| `main.dart` | ~18 000 строк — **не раздувать** | ~10 строк, логика в `lib/blocks/` |

---

## Архитектура v2

```
lib/
  main.dart          ← только runApp
  app.dart           ← MaterialApp, тема
  blocks/
    shell/           ← оболочка: главная, drawer
    core/            ← реестр стран, профиль (позже)
    ui/              ← цвета, общие виджеты
    countries/       ← PL, HU, RO…
      poland/
        systems/     ← eTOLL, SENT (с нуля)
```

- **Одна оболочка**, под неё — блоки стран.
- **Польша** — шаблон для остальных.
- Код v1 **не копируем** — только знаем логику.

---

## eTOLL refresh (v1 — священная цепочка)

Цель: получить **список карт** через пополнение, **не** через billing/details.

```
login → firm → financing/list → top-up 20 PLN → PayByNet → Dalej → gateway/tecspayment → STOP
```

- После отката v1 работает на коммите `047227f`: `_gotoBilling`, `_refreshInBackground`.
- `EtollRefreshPipeline` пробовали — ненадёжно, **откатили**.
- Бэкап блока баланса: `route_control/lib/backup/balance_block_locked_2026-06-27.zip`.
- Тег рабочего баланса: `v-balance-working`.

---

## Правила работы

1. **APK** — только по команде «собери» → `build/app/outputs/flutter-apk/app-debug.apk`.
2. **Firebase / Google** — ключи в консолях, не коммитить в git.
3. **Git commit** — только когда Oleg просит.
4. Новая логика eTOLL — в `blocks/`, не в `main.dart`.

---

## На другом ПК

```powershell
git clone https://github.com/burcovschioleg-svg/route-control-2.git
cd route-control-2
# Открыть в Cursor, в чате:
# «Прочитай docs/PROJECT_CONTEXT.md и docs/CHAT_HISTORY.md — продолжай v2»
```

Обновить историю чатов на этом ПК:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/export-chat-history.ps1
git add docs/CHAT_HISTORY.md
git commit -m "docs: update chat history"
git push
```
