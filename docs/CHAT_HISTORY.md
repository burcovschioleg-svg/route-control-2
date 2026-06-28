# Route Control — история проекта (с нуля)

> **Для Oleg и агента на другом ПК.**  
> Обновлено: 2026-06-28. Источник: текущая работа + Git, **не** старые бэкапы с флешек.

В новом чате Cursor напишите:

> Прочитай `docs/CHAT_HISTORY.md` — продолжай route_control_2

---

## 1. Что это за проект

**Route Control** — Flutter-приложение для перевозчиков.

- Вход через Google, Firebase.
- Несколько **фирм** (компаний), у каждой свой eTOLL.
- **Польша (eTOLL)** — первая и главная система: баланс счёта, пополнение, сохранение **банковских карт** для PayByNet.
- Позже: другие страны (HU, RO, SK, CZ…) — каждая отдельным блоком.
- Oleg **не программист** — ответы по-русски, простым языком.

**Цвета:** accent `#00D1FF`, eTOLL красный `#E2231A`, баланс зелёный `#34C77B`.

**Языки UI:** ru, ro, en, pl, de, fr, it, es, bg, uk (10 языков). Приоритет **английский** на eTOLL-сайте где возможно.

---

## 2. Законы разработки (запомнить)

1. **Баланс — святое.** Рабочий код баланса не ломать «заодно». Пополнение — отдельный поток от refresh баланса.
2. **Новый код — в blocks/**, не раздувать `main.dart` (в v1 он ~18 000 строк).
3. **APK** собирать **только по команде «собери»** — сборка 5–10+ минут. Путь APK:  
   `build/app/outputs/flutter-apk/app-debug.apk`
4. **Git commit / push** — только когда Oleg просит.
5. **Firebase / Google ключи** — не в git.
6. Если агент **застрял** на сложном куске — сказать Oleg переключить модель на Sonnet / GPT-5.4 (см. правила Cursor).
7. «Работает — не трогать» без явной просьбы.

---

## 3. Два проекта сейчас

| | v1 — архив | v2 — активный |
|---|------------|---------------|
| Папка | `C:\projects\route_control` | `C:\projects\route_control_2` |
| GitHub | [route-control](https://github.com/burcovschioleg-svg/route-control) | [route-control-2](https://github.com/burcovschioleg-svg/route-control-2) |
| Назначение | Эталон, рабочий APK, пример | Новая оболочка + блоки стран |
| main.dart | ~18k строк | ~10 строк |
| Git архив v1 | ветка `archive/v1-legacy`, тег `archive/v1-legacy-2026-06-28` | — |

**Решение (июнь 2026):** v1 заморозить, v2 писать **с нуля** — логику знаем, код v1 не копируем.

---

## 4. Как устроен v1 (архив)

```
lib/
  main.dart              ← огромный файл (исторически всё здесь)
  blocks/
    balance/             ← eTOLL refresh, куки, карты, top-up
    firms/               ← фирмы, mutex, логин
    transport/           ← транспорт
    settings/
    ui/
```

Рабочий коммит баланса после отката: **`047227f`** (Visa/MC, cardFirst4, отображение карт).

Тег рабочего баланса: **`v-balance-working`**.

---

## 5. eTOLL — главная логика

### 5.1 Что нужно пользователю

- Видеть **баланс** фирмы на eTOLL.
- **Обновить** баланс (refresh) через WebView в фоне.
- Сохранить **карты** (Visa/Mastercard, маска `44345…3645`) для выбора при пополнении.
- **Пополнить** счёт — отдельный экран, не ломая refresh.

### 5.2 Священная цепочка refresh (карты)

Цель refresh — **список карт**, не billing/details.

```
login → firm → financing/list → top-up 20 PLN → PayByNet → Dalej → gateway/tecspayment → STOP
```

- Карты получаем через **top-up**, не через страницу details/billing.
- На gateway/tecspayment парсим HTML (Tecspayment), сохраняем карты в store.
- После успеха refresh UI должен **закрыться** и показать обновлённые данные.

### 5.3 URL-ы (eTOLL PL)

- Логин: `https://etoll.gov.pl/login`
- Financing: `https://etoll.gov.pl/financing/list`
- Top-up в сессии, PayByNet, gateway — через WebView с cookies сессии.

### 5.4 Что пробовали и откатили

- **`EtollRefreshPipeline`** — новый пайплайн refresh в `blocks/balance/`. Работал нестабильно: карты иногда сохранялись, но refresh не закрывался, UI не финализировался.
- **Откат (июнь 2026):** вернули `_gotoBilling`, `_refreshInBackground` в `main.dart`, tracked-файлы `lib/blocks/balance/*` на HEAD `047227f`.
- Untracked файлы пайплайна остались на диске, но **не экспортируются** из восстановленного `balance.dart`.

### 5.5 Замороженный снимок блока баланса

Локально в v1: `lib/backup/balance_block_locked_2026-06-27.zip` — эталон блока на дату заморозки.

---

## 6. Хронология работ (по смыслу)

### Июнь 2026 — начало в Cursor на этом ПК

- Перенос рабочей папки на **`C:\projects`**, проект **`route_control`**.
- Настройка Cursor: ярлык, workspace `C:\projects`, история чатов привязана к workspace.
- Проверка пути APK: `C:\projects\route_control\build\app\outputs\flutter-apk`.

### UI и нативные экраны

- Обсуждение: заменить сайт eTOLL своими экранами (**вариант 3 — нативные Flutter-экраны**). Частично — UI пополнения (барабан суммы как у порога, зелёный).
- Иконки со **свечением/градиентом** (eTOLL красный, transport и др.).
- Предупреждение «данные устарели» — показывать только если реально не обновлялось; убрать ложные красные алерты.

### Баланс и пополнение

- **Refresh** не должен выкидывать на экран баланса при нажатии «Обновить» в пополнении.
- Смена фирмы → автообновление данных для пополнения.
- Язык eTOLL в WebView — приоритет **EN**.
- «Сменить карту» — отдельный путь, не тот же экран что пополнение.

### Карты — отдельный блок (не трогать рабочий баланс)

- Oleg: «рабочий баланс не трогать, карты — **новый блок**».
- Анализ: как раньше получали карты через financing → top-up → PayByNet → gateway.
- Парсер `EtollTecspaymentParser`, store `EtollCardListStore`, sync в сессии.
- Отображение: тип Visa/MC по первым цифрам, маска, название фирмы крупнее.
- Коммит **`047227f`**: card type, cardFirst4, company label.

### Git

- Баланс «под замком» на git — не ломать при пушах.
- Теги: `build-2`, `v-balance-working`, `archive/v1-legacy-2026-06-28`.
- **`ARCHIVE.md`** в v1 — пометка что v1 архив.

### Переход на v2

- Архитектура: **одна оболочка** + **блоки стран** (PL шаблон).
- Создан **`route_control_2`**: shell, country registry, PL/HU/RO заглушки.
- GitHub: **`route-control-2`**, чистый `main.dart`.
- Workspace: `C:\projects\route-control.code-workspace` (v1 + v2).

### История чатов на Git

- **`docs/CHAT_HISTORY.md`** — смысл проекта с нуля (главное для агента).
- **`docs/cursor-sessions/`** — **полные чаты** Cursor (jsonl + md), синхрон между ПК.
- Инструкция: **`docs/CURSOR_CHATS_SYNC.md`**.

Конец дня на ПК: `scripts/sync-chats.ps1` → `git push`.  
На другом ПК: `git pull` → `scripts/sync-chats.ps1` → перезапуск Cursor.

Список чатов **справа** в Cursor может не восстановиться (ограничение программы), но **агент читает файлы** в `cursor-sessions/`.

---

## 7. Архитектура v2 (активная)

```
lib/
  main.dart                 ← только runApp
  app.dart                  ← MaterialApp
  blocks/
    shell/                  ← главная, drawer
    core/                   ← country_registry
    ui/                     ← цвета
    countries/
      poland/
        poland_systems.dart ← eTOLL, SENT (заглушки)
      country_tile.dart
      country_systems_screen.dart
```

**Следующий шаг v2:** `countries/poland/systems/etoll/` — refresh и карты **с нуля**, по логике из раздела 5, без импорта v1 `main.dart`.

---

## 8. Cursor — правила в проекте

| Файл | Смысл |
|------|--------|
| `.cursor/rules/no-apk-until-done.mdc` | APK только по «собери» |
| `.cursor/rules/model-switch-hint.mdc` | Подсказка сменить модель если застряли |
| `.cursor/rules/shell-only-main.mdc` (v2) | main.dart не раздувать |
| `.cursor/rules/read-project-context.mdc` (v2) | Читать docs/ в начале |

---

## 9. Текущее состояние (на 2026-06-28)

| Что | Статус |
|-----|--------|
| v1 APK с откатом баланса | Собирался успешно после restore `047227f` |
| v2 shell | Создан, `flutter analyze` чистый |
| v2 GitHub | [route-control-2](https://github.com/burcovschioleg-svg/route-control-2) |
| eTOLL в v2 | Не начат (заглушки) |
| Firebase/Google в v2 | Не подключены (те же ключи что v1, package `com.routcontrol.route_control_v2`) |

---

## 10. Что делать дальше (очередь)

1. **v2:** каркас `poland/systems/etoll/` — cookies, login, firm, financing, top-up, gateway, cards store.
2. **v2:** Firebase + Google Sign-In (когда Oleg скажет).
3. **v1:** не трогать без явной просьбы — только справочник и APK.
4. **APK:** собирать только по «собери».

---

## 11. Краткий словарь

| Термин | Значение |
|--------|----------|
| Refresh | Фоновое обновление через WebView eTOLL |
| Top-up / пополнение | Пополнение счёта, отдельный UX |
| Firm / фирма | Компания перевозчика в приложении |
| PayByNet | Польская платёжная система на eTOLL |
| gateway/tecspayment | Страница выбора карты после Dalej |
| blocks/ | Модули кода вместо одного main.dart |

---

*Конец документа. При больших изменениях — обновить этот файл и `git push` в route-control-2.*
