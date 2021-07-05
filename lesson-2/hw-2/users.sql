DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    UNIQUE unique_name(name)
);

INSERT INTO users VALUES
    (DEFAULT, 'ivan.ivanov'),
    (DEFAULT, 'petr.petrov'),
    (DEFAULT, 'sidr.sidorov');

DESCRIBE users;
SELECT * FROM users;
