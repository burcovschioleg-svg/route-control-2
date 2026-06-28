# Синхронизация чатов Cursor между ПК

Чаты **справа в Cursor** хранятся только на этом компьютере.  
Через Git мы синхронизируем **содержимое** — агент на другом ПК его прочитает.

## Быстро

### Конец работы на этом ПК

```powershell
cd C:\projects\route_control_2
powershell -ExecutionPolicy Bypass -File scripts\sync-chats.ps1
git add docs/cursor-sessions
git commit -m "sync: cursor chats"
git push
```

### Начало на другом ПК

```powershell
cd C:\projects\route_control_2
git pull
powershell -ExecutionPolicy Bypass -File scripts\sync-chats.ps1
```

Перезапустить Cursor. В новом чате:

> Прочитай docs/CHAT_HISTORY.md и docs/cursor-sessions/ — продолжай v2

## Что синхронизируется

| Файл | Назначение |
|------|------------|
| `docs/cursor-sessions/*.jsonl` | Сырые сессии (для агента) |
| `docs/cursor-sessions/*.md` | Те же чаты **читаемым текстом** (открыть в редакторе) |
| `docs/cursor-sessions/manifest.json` | Даты и размеры |
| `docs/CHAT_HISTORY.md` | Краткая история проекта с нуля |

## Список чатов справа в Cursor

**Может не появиться** после импорта — это ограничение Cursor, не Git.  
Но агент **видит** сессии через файлы в `docs/cursor-sessions/`.  
Читать глазами: откройте `faca3992-....md` (самая большая сессия).

## Два направления

`sync-chats.ps1` без параметров — **слияние**: новее побеждает (этот ПК ↔ Git).

- `-Push` — только выгрузить с этого ПК в git  
- `-Pull` — только загрузить из git в Cursor

## Папки на диске

- Git: `route_control_2\docs\cursor-sessions\`
- Cursor: `%USERPROFILE%\.cursor\projects\c-projects\agent-transcripts\`
