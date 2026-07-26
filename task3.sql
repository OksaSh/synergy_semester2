DROP DATABASE IF EXISTS tourism_db;

CREATE DATABASE tourism_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE tourism_db;

-- Справочник стран

CREATE TABLE countries
(
    country_id INT UNSIGNED AUTO_INCREMENT,
    country_name VARCHAR(100) NOT NULL,
    visa_required BOOLEAN NOT NULL DEFAULT FALSE,
    description VARCHAR(500),

    CONSTRAINT pk_countries
        PRIMARY KEY (country_id),

    CONSTRAINT uq_countries_name
        UNIQUE (country_name)
);

-- Справочник отелей

CREATE TABLE hotels
(
    hotel_id INT UNSIGNED AUTO_INCREMENT,
    country_id INT UNSIGNED NOT NULL,
    hotel_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    stars TINYINT UNSIGNED NOT NULL,
    price_per_night DECIMAL(10, 2) NOT NULL,

    CONSTRAINT pk_hotels
        PRIMARY KEY (hotel_id),

    CONSTRAINT fk_hotels_country
        FOREIGN KEY (country_id)
        REFERENCES countries (country_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_hotels_stars
        CHECK (stars BETWEEN 1 AND 5),

    CONSTRAINT chk_hotels_price
        CHECK (price_per_night >= 0)
);

-- Справочник типов туров

CREATE TABLE tour_types
(
    tour_type_id INT UNSIGNED AUTO_INCREMENT,
    tour_type_name VARCHAR(100) NOT NULL,
    description VARCHAR(500),

    CONSTRAINT pk_tour_types
        PRIMARY KEY (tour_type_id),

    CONSTRAINT uq_tour_types_name
        UNIQUE (tour_type_name)
);

-- Справочник дополнительных услуг

CREATE TABLE services
(
    service_id INT UNSIGNED AUTO_INCREMENT,
    service_name VARCHAR(150) NOT NULL,
    service_price DECIMAL(10, 2) NOT NULL DEFAULT 0,
    description VARCHAR(500),

    CONSTRAINT pk_services
        PRIMARY KEY (service_id),

    CONSTRAINT uq_services_name
        UNIQUE (service_name),

    CONSTRAINT chk_services_price
        CHECK (service_price >= 0)
);

-- Таблица заказов туров

CREATE TABLE tour_orders
(
    order_id INT UNSIGNED AUTO_INCREMENT,
    customer_name VARCHAR(150) NOT NULL,
    customer_phone VARCHAR(30) NOT NULL,
    customer_email VARCHAR(150),

    country_id INT UNSIGNED NOT NULL,
    hotel_id INT UNSIGNED NOT NULL,
    tour_type_id INT UNSIGNED NOT NULL,
    service_id INT UNSIGNED NULL,

    departure_date DATE NOT NULL,
    return_date DATE NOT NULL,
    persons_count INT UNSIGNED NOT NULL DEFAULT 1,
    total_price DECIMAL(12, 2) NOT NULL,

    order_status ENUM(
        'Новый',
        'Подтвержден',
        'Оплачен',
        'Завершен',
        'Отменен'
    ) NOT NULL DEFAULT 'Новый',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_tour_orders
        PRIMARY KEY (order_id),

    CONSTRAINT fk_orders_country
        FOREIGN KEY (country_id)
        REFERENCES countries (country_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_hotel
        FOREIGN KEY (hotel_id)
        REFERENCES hotels (hotel_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_tour_type
        FOREIGN KEY (tour_type_id)
        REFERENCES tour_types (tour_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_orders_service
        FOREIGN KEY (service_id)
        REFERENCES services (service_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT chk_orders_dates
        CHECK (return_date > departure_date),

    CONSTRAINT chk_orders_persons
        CHECK (persons_count > 0),

    CONSTRAINT chk_orders_total_price
        CHECK (total_price >= 0)
);

-- Индексы

CREATE INDEX idx_hotels_country
    ON hotels (country_id);

CREATE INDEX idx_orders_country
    ON tour_orders (country_id);

CREATE INDEX idx_orders_hotel
    ON tour_orders (hotel_id);

CREATE INDEX idx_orders_tour_type
    ON tour_orders (tour_type_id);

CREATE INDEX idx_orders_service
    ON tour_orders (service_id);

-- Тестовые данные

INSERT INTO countries
(
    country_name,
    visa_required,
    description
)
VALUES
(
    'Турция',
    FALSE,
    'Популярное направление для пляжного отдыха'
),
(
    'Египет',
    TRUE,
    'Пляжный и экскурсионный отдых'
),
(
    'Италия',
    TRUE,
    'Экскурсионный и культурный туризм'
),
(
    'Россия',
    FALSE,
    'Внутренний туризм'
);

INSERT INTO hotels
(
    country_id,
    hotel_name,
    city,
    stars,
    price_per_night
)
VALUES
(
    1,
    'Antalya Sea Resort',
    'Анталья',
    5,
    12500.00
),
(
    1,
    'Side Family Hotel',
    'Сиде',
    4,
    8500.00
),
(
    2,
    'Hurghada Beach Hotel',
    'Хургада',
    5,
    11000.00
),
(
    3,
    'Roma Central Hotel',
    'Рим',
    4,
    14500.00
),
(
    4,
    'Сочи Парк Отель',
    'Сочи',
    4,
    9000.00
);

INSERT INTO tour_types
(
    tour_type_name,
    description
)
VALUES
(
    'Пляжный',
    'Отдых на морском побережье'
),
(
    'Экскурсионный',
    'Посещение культурных и исторических мест'
),
(
    'Горнолыжный',
    'Зимний отдых на горнолыжных курортах'
),
(
    'Оздоровительный',
    'Отдых в санаториях и оздоровительных комплексах'
);

INSERT INTO services
(
    service_name,
    service_price,
    description
)
VALUES
(
    'Трансфер из аэропорта',
    3500.00,
    'Доставка туриста из аэропорта до отеля'
),
(
    'Медицинская страховка',
    2500.00,
    'Страхование туриста на период поездки'
),
(
    'Экскурсионная программа',
    6000.00,
    'Групповая экскурсия с гидом'
),
(
    'Оформление визы',
    9500.00,
    'Подготовка документов для получения визы'
);

INSERT INTO tour_orders
(
    customer_name,
    customer_phone,
    customer_email,
    country_id,
    hotel_id,
    tour_type_id,
    service_id,
    departure_date,
    return_date,
    persons_count,
    total_price,
    order_status
)
VALUES
(
    'Иванов Иван Иванович',
    '+7-900-111-22-33',
    'ivanov@example.com',
    1,
    1,
    1,
    1,
    '2026-08-10',
    '2026-08-20',
    2,
    185000.00,
    'Оплачен'
),
(
    'Петрова Анна Сергеевна',
    '+7-900-444-55-66',
    'petrova@example.com',
    3,
    4,
    2,
    4,
    '2026-09-05',
    '2026-09-12',
    1,
    145000.00,
    'Подтвержден'
);

-- Проверочный запрос

SELECT
    o.order_id,
    o.customer_name,
    c.country_name,
    h.hotel_name,
    tt.tour_type_name,
    s.service_name,
    o.departure_date,
    o.return_date,
    o.persons_count,
    o.total_price,
    o.order_status
FROM tour_orders AS o
INNER JOIN countries AS c
    ON c.country_id = o.country_id
INNER JOIN hotels AS h
    ON h.hotel_id = o.hotel_id
INNER JOIN tour_types AS tt
    ON tt.tour_type_id = o.tour_type_id
LEFT JOIN services AS s
    ON s.service_id = o.service_id;