--DDL

CREATE TABLE planes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    date_end DATE NOT NULL,
    cost NUMERIC(10,2) NOT NULL CHECK (cost >= 0)
);

CREATE TABLE members (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    start_date DATE NOT NULL,
    plan_id INT NOT NULL REFERENCES planes(id)
);

CREATE TABLE traners (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    salary NUMERIC(10,2) NOT NULL CHECK (salary >= 0),
    specialty VARCHAR(100) NOT NULL,
    years_of_experience INT NOT NULL CHECK (years_of_experience >= 0)
);

CREATE TABLE locars (
    id SERIAL PRIMARY KEY,
    members_id INT UNIQUE NOT NULL REFERENCES members(id)
);

CREATE TABLE classes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    scheduled_time TIMESTAMP NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
    max_capacity INT NOT NULL CHECK (max_capacity > 0),
    trainer_id INT NOT NULL REFERENCES traners(id)
);

CREATE TABLE class_bookings (
    members_id INT REFERENCES members(id),
    classes_id INT REFERENCES classes(id),
    booking_date DATE NOT NULL DEFAULT CURRENT_DATE,
    PRIMARY KEY (members_id, classes_id)
);

--DML


INSERT INTO planes (name, date_end, cost)
VALUES
('Basic', '2026-12-31', 500),
('Premium', '2026-12-31', 1000),
('VIP', '2026-12-31', 1500);

INSERT INTO members (name, phone, email, start_date, plan_id)
VALUES
('Ahmed Ali', '01011111111', 'ahmed@gmail.com', '2026-01-10', 1),
('Mohamed Hassan', '01022222222', 'mohamed@gmail.com', '2026-02-15', 2),
('Omar Samir', '01033333333', 'omar@gmail.com', '2026-03-01', 3),
('Ali Mahmoud', '01044444444', 'ali@gmail.com', '2026-04-05', 1),
('Youssef Mostafa', '01055555555', 'youssef@gmail.com', '2026-05-20', 2);

INSERT INTO traners
(name, phone, email, salary, specialty, years_of_experience)
VALUES
('Karim Adel', '01111111111', 'karim@gmail.com', 8000, 'Yoga', 5),
('Omar Fathy', '01122222222', 'omar.fathy@gmail.com', 9000, 'Cardio', 3),
('Hassan Tarek', '01133333333', 'hassan@gmail.com', 12000, 'Weights', 8);

INSERT INTO locars (members_id)
VALUES (1), (2), (3), (4), (5);

INSERT INTO classes
(name, scheduled_time, duration_minutes, max_capacity, trainer_id)
VALUES
('Morning Yoga', '2026-10-25 08:00:00', 60, 20, 1),
('HIIT Bootcamp', '2026-10-25 10:00:00', 45, 15, 2),
('Weight Training', '2026-10-25 17:00:00', 60, 12, 3),
('Evening Yoga', '2026-10-26 18:00:00', 60, 20, 1);

INSERT INTO class_bookings (members_id, classes_id)
VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 3),
(3, 2),
(3, 3),
(4, 1),
(5, 4);


--DQL


-- Query 1: Display members and their plan IDs
SELECT
    name,
    plan_id
FROM members;


-- Query 2: Display classes and their trainer IDs
SELECT
    name,
    trainer_id
FROM classes;


-- Query 3: Display members subscribed to Premium
SELECT name
FROM members
WHERE plan_id = (
    SELECT id
    FROM planes
    WHERE name = 'Premium'
);


-- Query 4: Count bookings for each class
SELECT
    classes_id,
    COUNT(*) AS total_bookings
FROM class_bookings
GROUP BY classes_id;


-- Query 5: Display members who booked class 1
SELECT name
FROM members
WHERE id IN (
    SELECT members_id
    FROM class_bookings
    WHERE classes_id = 1
);
