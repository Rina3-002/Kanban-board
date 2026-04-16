CREATE TABLE kanban_board ( --Таблица канбан-доски
    id_board SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    owner VARCHAR(255) NOT NULL,
    max_tracks_count INTEGER NOT NULL DEFAULT 5 CHECK (max_tracks_count > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO kanban_board (name, owner) VALUES ('Проект 29103', 'Дягерев А.Ю.');

CREATE TABLE tracks_kanban_board ( --Таблица дорожек канбан-доски
    id_track SERIAL PRIMARY KEY,
    id_board INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    position_track INTEGER NOT NULL,
    max_card_count INTEGER NOT NULL DEFAULT 100 CHECK (max_card_count > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_board FOREIGN KEY (id_board) REFERENCES kanban_board(id_board)
      ON DELETE CASCADE
);

INSERT INTO tracks_kanban_board (id_board, name, position_track)
VALUES (1, 'Создано', 1),
(1, 'В работе', 2),
(1, 'На согласовании', 3),
(1, 'Отслеживание', 4),
(1, 'В архиве', 5);