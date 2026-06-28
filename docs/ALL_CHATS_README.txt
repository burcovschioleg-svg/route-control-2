ВЕСЬ ТЕКСТ ЧАТОВ — один файл

  docs/ALL_CHATS.txt   (или ALL_CHATS.md — то же самое)

На другом ПК:
  1. git pull
  2. Открыть ALL_CHATS.txt в Cursor
  3. В чате: «Прочитай ALL_CHATS.txt и CHAT_HISTORY.md — продолжай v2»

Обновить перед уходом:
  powershell -File scripts\sync-chats.ps1
  git add docs/ALL_CHATS.txt docs/ALL_CHATS.md
  git commit -m "sync: all chats"
  git push
