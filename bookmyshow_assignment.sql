-- BookMyShow Theatre Show Listing Assignment
-- MySQL 8.x

CREATE DATABASE IF NOT EXISTS bookmyshow_assignment;
USE bookmyshow_assignment;

-- 1. THEATRE
CREATE TABLE theatre (
    theatre_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    theatre_name VARCHAR(150) NOT NULL,
    city VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    UNIQUE KEY uq_theatre_name_address (theatre_name, address)
) ENGINE=InnoDB;

-- 2. SCREEN / AUDITORIUM
CREATE TABLE screen (
    screen_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    theatre_id INT UNSIGNED NOT NULL,
    screen_name VARCHAR(50) NOT NULL,
    total_seats INT UNSIGNED NOT NULL,
    UNIQUE KEY uq_screen_theatre_name (theatre_id, screen_name),
    CONSTRAINT fk_screen_theatre
        FOREIGN KEY (theatre_id) REFERENCES theatre(theatre_id)
) ENGINE=InnoDB;

-- 3. MOVIE
CREATE TABLE movie (
    movie_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    movie_title VARCHAR(200) NOT NULL,
    UNIQUE KEY uq_movie_title (movie_title)
) ENGINE=InnoDB;

-- 4. SHOW
-- A show is one scheduled screening of one movie in one screen.
-- theatre_id is intentionally NOT stored here because it is functionally
-- determined by screen_id; storing it would introduce redundancy.
CREATE TABLE show_schedule (
    show_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    screen_id INT UNSIGNED NOT NULL,
    movie_id INT UNSIGNED NOT NULL,
    language VARCHAR(50) NOT NULL,
    screen_format VARCHAR(20) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NULL,
    UNIQUE KEY uq_screen_start (screen_id, start_time),
    CONSTRAINT fk_show_screen
        FOREIGN KEY (screen_id) REFERENCES screen(screen_id),
    CONSTRAINT fk_show_movie
        FOREIGN KEY (movie_id) REFERENCES movie(movie_id)
) ENGINE=InnoDB;

-- SAMPLE DATA

INSERT INTO theatre (theatre_name, city, address) VALUES
('PVR: Nexus', 'Lucknow', 'Nexus Mall, Lucknow'),
('INOX Megaplex', 'Lucknow', 'Phoenix Palassio, Lucknow');

INSERT INTO screen (theatre_id, screen_name, total_seats) VALUES
(1, 'Audi 1', 180),
(1, 'Audi 2', 150),
(2, 'Audi 1', 200);

INSERT INTO movie (movie_title) VALUES
('Dasara'),
('Kisi Ka Bhai Kisi Ki Jaan'),
('Tu Jhoothi Main Makkaar'),
('Avatar: The Way of Water');

INSERT INTO show_schedule
(screen_id, movie_id, language, screen_format, start_time, end_time)
VALUES
(1, 1, 'Telugu', '2D', '2026-09-25 12:15:00', '2026-09-25 14:45:00'),
(1, 2, 'Hindi',  '2D', '2026-09-25 13:00:00', '2026-09-25 15:00:00'),
(1, 2, 'Hindi',  '4DX', '2026-09-25 16:40:00', '2026-09-25 18:40:00'),
(1, 3, 'Hindi',  '2D', '2026-09-25 19:15:00', '2026-09-25 21:35:00'),
(1, 4, 'English','2D', '2026-09-25 20:20:00', '2026-09-25 23:10:00'),
(1, 4, 'English','3D', '2026-09-25 21:30:00', '2026-09-25 00:20:00');

INSERT INTO show_schedule
(screen_id, movie_id, language, screen_format, start_time, end_time)
VALUES
(2, 1, 'Telugu', '2D', '2026-09-26 10:30:00', '2026-09-26 13:00:00'),
(2, 3, 'Hindi',  '2D', '2026-09-26 15:00:00', '2026-09-26 17:20:00'),
(3, 4, 'English','3D', '2026-09-25 18:00:00', '2026-09-25 20:50:00');

-- P2: List all shows on a given date at a given theatre.
-- Parameters:
--   :theatre_id = requested theatre
--   :show_date  = requested date
--
-- Example below: theatre_id = 1, date = 2026-09-25

SELECT
    t.theatre_name,
    s.screen_name,
    m.movie_title,
    ss.language,
    ss.screen_format,
    DATE(ss.start_time) AS show_date,
    TIME(ss.start_time) AS show_time,
    ss.start_time,
    ss.end_time
FROM theatre AS t
JOIN screen AS s
    ON s.theatre_id = t.theatre_id
JOIN show_schedule AS ss
    ON ss.screen_id = s.screen_id
JOIN movie AS m
    ON m.movie_id = ss.movie_id
WHERE t.theatre_id = 1
  AND ss.start_time >= '2026-09-25 00:00:00'
  AND ss.start_time <  '2026-09-26 00:00:00'
ORDER BY ss.start_time;

-- Parameterized form for application code:
-- WHERE t.theatre_id = :theatre_id
--   AND ss.start_time >= :show_date
--   AND ss.start_time < DATE_ADD(:show_date, INTERVAL 1 DAY);

-- Optional P2 query using theatre name instead of theatre_id:
SELECT
    t.theatre_name,
    s.screen_name,
    m.movie_title,
    ss.language,
    ss.screen_format,
    TIME(ss.start_time) AS show_time
FROM theatre AS t
JOIN screen AS s ON s.theatre_id = t.theatre_id
JOIN show_schedule AS ss ON ss.screen_id = s.screen_id
JOIN movie AS m ON m.movie_id = ss.movie_id
WHERE t.theatre_name = 'PVR: Nexus'
  AND ss.start_time >= '2026-09-25 00:00:00'
  AND ss.start_time <  '2026-09-26 00:00:00'
ORDER BY ss.start_time;
