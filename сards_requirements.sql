-- CREATE TYPE priority_enum AS ENUM ('Низкий', 'Средний', 'Высокий');
-- CREATE TYPE importance_estimate AS ENUM ('Очень низкая', 'Низкая', 'Низкая+', 'Ниже среднего', 'Средняя', 'Средняя+', 'Высокая','Очень высокая', 'Критическая','Максимальная');

CREATE TABLE znf ( --Таблица ЗНФ
    id_znf SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    deadline TIMESTAMP NOT NULL,
    customer VARCHAR(255) NOT NULL,
    owner VARCHAR(255) NOT NULL,
    responsible_analyst VARCHAR(255) NOT NULL
);

INSERT INTO znf (description, deadline, customer, owner, responsible_analyst)
VALUES ('Создание панели для мониторинга данных', '2026-05-01', 'Компания А', 'Иванов И.И.', 'Петрова А.В.');

CREATE TABLE backlog (  --Таблица Бэклога
    id_backlog SERIAL PRIMARY KEY,
    type_znf VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    status_znf VARCHAR(255) NOT NULL,
    customer VARCHAR(255) NOT NULL,
    responsible_analyst VARCHAR(255) NOT NULL,
    deadline TIMESTAMP NOT NULL,
    working_days_estimate INTEGER NOT NULL,
    ready_for_start TIMESTAMP NOT NULL,
    priority priority_enum NOT NULL,
    owner VARCHAR(255) NOT NULL,
    comments TEXT
);

INSERT INTO backlog (
    type_znf, description, status_znf, customer, responsible_analyst, deadline,
    working_days_estimate, ready_for_start, priority, owner, comments
)
VALUES
('Проект',
'Разработка панели управления для мониторинга данных с настройкой интерфейса, ограничением доступа пользователей и оптимизацией расположения элементов.',
'В работе', 'Компания А', 'Петрова А.В.', '2026-05-15', 20, '2026-04-15', 'Высокий', 'Иванов И.И.',
'Включает несколько подзадач: настройка панели, управление доступом, оптимизация интерфейса.');

CREATE TABLE card_requirements ( --Таблица Карточки требований
    id_card SERIAL PRIMARY KEY,
    id_znf INTEGER NOT NULL,
    id_backlog INTEGER NOT NULL,
    id_track INTEGER,
    name VARCHAR(255) NOT NULL,
    short_description TEXT NOT NULL,
    owner VARCHAR(255) NOT NULL,
    customer VARCHAR(255) NOT NULL,
    requirement_type VARCHAR(255) NOT NULL,
    deadline TIMESTAMP NOT NULL,
    importance_estimate importance_estimate,

    CONSTRAINT fk_znf FOREIGN KEY (id_znf) REFERENCES znf(id_znf) ON DELETE CASCADE,
    CONSTRAINT fk_backlog FOREIGN KEY (id_backlog) REFERENCES backlog(id_backlog) ON DELETE CASCADE
);

INSERT INTO card_requirements (id_znf, id_backlog, id_track, name, short_description, owner, customer, requirement_type, deadline, importance_estimate)
VALUES
(1, 1, 1, 'Настройка панели для мониторинга данных', 'Разработка панели управления для отображения статистики в реальном времени', 'Иванов И.И., Петрова А.В.', 'Компания А', 'Проект', '2026-05-15', 'Высокая'),
(1, 1, 2, 'Ограничение функционала панели', 'Разработка функционала для ограничения прав пользователей и доступа к панели', 'Иванов И.И., Сидоров Р.К.', 'Компания А', 'Проект', '2026-05-15', 'Средняя'),
(1, 1, 3, 'Оптимизация расположения кнопок в панели управления', 'Реализация удобного расположения кнопок и элементов на панели управления', 'Иванов И.И., Кузнецова У.Х.', 'Компания А', 'Проект', '2026-05-15', 'Средняя'),
(1, 1, 4, 'Ограничение доступа к функционалу панели', 'Разработка системы ограничения доступа для различных ролей пользователей', 'Иванов И.И.', 'Компания А', 'Проект', '2026-05-15', 'Очень высокая'),
(1, 1, 5, 'Оптимизация элементов страницы настроек', 'Перераспределение элементов на странице настроек для повышения удобства использования', 'Иванов И.И., Петрова А.В.', 'Компания А', 'Проект', '2026-05-15', 'Низкая+');

CREATE TABLE user_requirements ( --Таблица Пользовательские требования
    id_pt SERIAL PRIMARY KEY,
    id_card INTEGER NOT NULL,
    encoding VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL,
    action TEXT NOT NULL,
    value TEXT NOT NULL,
    usage_scenario TEXT NOT NULL,
    acceptance_criteria TEXT NOT NULL,
    priority priority_enum NOT NULL,

    CONSTRAINT fk_card FOREIGN KEY (id_card) REFERENCES card_requirements(id_card) ON DELETE CASCADE
);

INSERT INTO user_requirements (id_card, encoding, role, action, value, usage_scenario, acceptance_criteria, priority)
VALUES
(1, 'ПТ-1', 'Администратор', 'Должен иметь возможность просматривать панель мониторинга',
'Доступ к панели и статистике в реальном времени',
 'Администратор открывает панель, выбирает нужные показатели, проверяет отображение статистики и фильтров.',
 'Все элементы панели отображаются корректно, кнопки активны и фильтры работают', 'Высокий'),
(2, 'ПТ-1', 'Пользователь', 'Должен иметь ограниченный доступ к функционалу панели',
'Доступ только к разрешённым функциям',
 'Use Case: Пользователь с ограниченными правами пытается выполнить действия, доступные только администратору, и получает сообщение об ограничении.',
 'Запрещённые действия недоступны, корректное отображение уведомления о запрете', 'Средний'),
(3, 'ПТ-1', 'Администратор', 'Должен иметь возможность перемещать кнопки и элементы панели',
'Удобство расположения элементов панели',
 'Администратор перетаскивает кнопки на панели, проверяет новое расположение и сохраняет его.',
 'Элементы панели корректно перемещаются, изменения сохраняются и отображаются после перезагрузки', 'Средний'),
(4, 'ПТ-1', 'Администратор', 'Должен иметь возможность ограничивать доступ пользователей',
'Настройка системы ролей и прав доступа',
 'Администратор назначает роли пользователям, проверяет, что пользователи видят только разрешённые функции.',
 'Пользователи с разными ролями видят только разрешённые функции, доступ к остальному блокирован', 'Высокий'),
(5, 'ПТ-1', 'Администратор', 'Должен иметь возможность оптимизировать элементы страницы настроек',
'Удобство использования интерфейса',
 'Администратор открывает страницу настроек, перемещает элементы, проверяет удобство интерфейса и сохраняет изменения.',
 'Элементы страницы корректно отображаются, интерфейс интуитивно понятен', 'Низкий');

CREATE TABLE functional_requirements ( --Таблица Функциональные требования
    id_ft SERIAL PRIMARY KEY,
    id_card INTEGER NOT NULL,
    encoding VARCHAR(255) NOT NULL,
    short_description TEXT NOT NULL,
    details TEXT NOT NULL,
    priority priority_enum NOT NULL,

    CONSTRAINT fk_card FOREIGN KEY (id_card) REFERENCES card_requirements(id_card) ON DELETE CASCADE
);

INSERT INTO functional_requirements (id_card, encoding, short_description, details, priority)
VALUES
(1, 'ФТ-1', 'Отображение панели мониторинга', 'Система должна отображать статистику в реальном времени с возможностью фильтрации и сортировки данных', 'Высокий'),
(2, 'ФТ-1', 'Ограничение функционала панели', 'Система должна блокировать доступ к функционалу в зависимости от роли пользователя', 'Средний'),
(3, 'ФТ-1', 'Перемещение элементов панели', 'Система должна позволять перемещать кнопки и элементы панели и сохранять новое расположение', 'Средний'),
(4, 'ФТ-1', 'Система ролей и доступа', 'Система должна поддерживать настройку прав доступа для различных пользователей и ролей', 'Высокий'),
(5, 'ФТ-1', 'Оптимизация интерфейса страницы настроек', 'Система должна позволять редактировать расположение элементов на странице настроек для улучшения UX', 'Низкий');

CREATE TABLE non_functional_requirements ( --Таблица Нефункциональные требования
    id_nft SERIAL PRIMARY KEY,
    id_card INTEGER NULL,
    encoding VARCHAR(255) DEFAULT NULL,
    description TEXT DEFAULT NULL,
    explanation TEXT DEFAULT NULL,

    CONSTRAINT fk_card FOREIGN KEY (id_card) REFERENCES card_requirements(id_card) ON DELETE CASCADE
);

INSERT INTO non_functional_requirements (id_card, encoding, description, explanation) VALUES
(1, 'НФТ-1', 'Скорость отклика панели', 'Панель должна загружаться за менее чем 2 секунды при стандартной нагрузке'),
(3, 'НФТ-1', 'Кросс-браузерная совместимость', 'Элементы панели должны корректно отображаться в последних версиях Chrome, Firefox и Edge');

CREATE TABLE integrations_and_data ( --Таблица Интеграции и данные
    id_integration SERIAL PRIMARY KEY,
    id_card INTEGER NULL,
    api_endpoint VARCHAR(255) DEFAULT NULL,
    data_format VARCHAR(255) DEFAULT NULL,
    scripts TEXT DEFAULT NULL,

    CONSTRAINT fk_card FOREIGN KEY (id_card) REFERENCES card_requirements(id_card) ON DELETE CASCADE
);

INSERT INTO integrations_and_data (id_card, api_endpoint, data_format, scripts) VALUES
(1, '/api/monitoring/get_stats', 'JSON', 'function fetchStats() { /запрос данных/ }'),
(3, '/api/panel/update_layout', 'JSON', 'function updateLayout() { /обновление расположения элементов/ }');

CREATE TABLE media ( --Таблица Медиа
    id_media SERIAL PRIMARY KEY,
    id_card INTEGER NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    file_type VARCHAR(255) NOT NULL,
    file_size BIGINT NOT NULL,
    file_link VARCHAR(255) NOT NULL,
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uploaded_by VARCHAR(255) NOT NULL,

    CONSTRAINT fk_card FOREIGN KEY (id_card) REFERENCES card_requirements(id_card) ON DELETE CASCADE
);

INSERT INTO media (id_card, file_name, file_type, file_size, file_link, upload_date, uploaded_by)
VALUES (1, '1.png', 'image/png', 55408, '/files/1.png', '2026-04-07', 'Иванов И.И.'),
(2, '2.png', 'image/png', 48423, '/files/2.png', '2026-04-07', 'Иванов И.И.'),
(3, '3.png', 'image/png', 171520, '/files/3.png', '2026-04-07', 'Иванов И.И.'),
(4, '4.png', 'image/png', 241664, '/files/4.png', '2026-04-07', 'Иванов И.И.'),
(5, '5.png', 'image/png', 114688, '/files/5.png', '2026-04-07', 'Иванов И.И.');