# Kanban Board

Веб-интерфейс для управления требованиями в формате Kanban-доски.

## Как установить и запустить проект

### 1. Клонируйте репозиторий
```bash
git clone https://github.com/Rina3-002/Requirements.git
cd Requirements
```

Или просто скачайте ZIP-архив через кнопку **Code → Download ZIP** и распакуйте его.

### 2. Установите зависимости
Убедитесь, что у вас установлен [Node.js](https://nodejs.org/). Затем выполните в терминале:
```bash
npm init -y
npm install express pg
npm install multer
```

### 3. Настройте базу данных PostgreSQL
- Установите [PostgreSQL](https://www.postgresql.org/download/) если ещё не установлен.
- Создайте базу данных для проекта (например, `kanban_db`).
- В папке `server` создайте файл `.env` или настройте подключение в `server.js` под свои данные:
  ```javascript
  const pool = new Pool({
      user: 'ваш_пользователь',
      host: 'localhost',
      database: 'kanban_db',
      password: 'ваш_пароль',
      port: 5432,
  });
  ```

### 4. Запустите сервер
```bash
cd kanban_board
node server/server.js
```
После запуска вы увидите сообщение в консоли: `Сервер запущен на порту XXXX`.

### 5. Откройте приложение в браузере
Перейдите по адресу: [http://localhost:3000](http://localhost:3000) (или тот порт, который указан в вашем `server.js`).

## Структура проекта
```
Requirements/                          # Корневая папка проекта
│
├── package.json                       # Список зависимостей Node.js (express, mysql и т.д.)
│
├── package-lock.json                  # Зафиксированные точные версии всех библиотек
│
├── kanban_tracks.sql                  # SQL-скрипт для БД1
│
├── cards_requirements.sql             # SQL-скрипт для БД2
│
└── kanban_board/                      # Основная папка приложения
    │
    ├── public/                        # ФРОНТЕНД
    │   ├── index.html                 # Главная HTML-страница канбан-доски
    │   ├── script.js                  # Логика на JavaScript
    │   └── style.css                  # Стили оформления
    │
    ├── server/                        # БЭКЕНД
    │   └── server.js                  # Код сервера на Node.js + Express, подключение к MySQL
    │
    └── files/                         # Статические изображения для карточек задач
        ├── 1.jpg
        ├── 2.jpg
        ├── 3.png
        ├── 4.png
        └── 5.png
```

## Примечания
- Если вы используете другой порт, убедитесь, что он не занят.
- Папка `uploads` создаётся автоматически при первой загрузке файла.
- Для работы с PostgreSQL убедитесь, что базы данных правильно настроены и заполнены.
