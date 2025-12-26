-- ============================================
-- Auto-Vermietungssystem Database Schema
-- ============================================
-- Erstellt: 2025-12-22
-- Beschreibung: Vollständige Datenbankstruktur für das Auto-Vermietungssystem
-- ============================================

-- Datenbank erstellen und auswählen
DROP DATABASE IF EXISTS auto_vermietung;
CREATE DATABASE auto_vermietung CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE auto_vermietung;

-- ============================================
-- Tabelle: users
-- Beschreibung: Speichert Benutzerinformationen (Admin & Kunden)
-- ============================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL COMMENT 'Gehashtes Passwort mit password_hash()',
    role ENUM('admin', 'customer') NOT NULL DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabelle: cars
-- Beschreibung: Speichert Auto-Informationen
-- ============================================
CREATE TABLE cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    brand VARCHAR(50) NOT NULL COMMENT 'Automarke (z.B. BMW, Mercedes)',
    model VARCHAR(50) NOT NULL COMMENT 'Modell (z.B. 3er, C-Klasse)',
    year INT NOT NULL COMMENT 'Baujahr',
    price_per_day DECIMAL(10, 2) NOT NULL COMMENT 'Preis pro Tag in EUR',
    status ENUM('available', 'rented', 'maintenance') NOT NULL DEFAULT 'available',
    image VARCHAR(255) DEFAULT NULL COMMENT 'Pfad zum Autobild',
    description TEXT DEFAULT NULL COMMENT 'Beschreibung des Autos',
    features TEXT DEFAULT NULL COMMENT 'Ausstattungsmerkmale (JSON oder kommagetrennt)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_brand (brand),
    INDEX idx_status (status),
    INDEX idx_price (price_per_day),
    INDEX idx_year (year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Tabelle: bookings
-- Beschreibung: Speichert Buchungsinformationen
-- ============================================
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    car_id INT NOT NULL,
    start_date DATE NOT NULL COMMENT 'Mietbeginn',
    end_date DATE NOT NULL COMMENT 'Mietende',
    total_price DECIMAL(10, 2) NOT NULL COMMENT 'Gesamtpreis der Buchung',
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_car_id (car_id),
    INDEX idx_dates (start_date, end_date),
    INDEX idx_status (status),
    CONSTRAINT chk_dates CHECK (end_date >= start_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;



INSERT INTO users (username, email, password, role) VALUES
('admin', 'admin@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin'),
('max_mueller', 'max.mueller@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer'),
('anna_schmidt', 'anna.schmidt@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer'),
('peter_weber', 'peter.weber@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer'),
('lisa_meyer', 'lisa.meyer@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'customer');

-- ============================================
-- Seed Data: Autos
-- ============================================
INSERT INTO cars (brand, model, year, price_per_day, status, description, features) VALUES
('BMW', '3er', 2022, 89.99, 'available', 'Sportliche Limousine mit modernster Technologie', 'Klimaanlage,Navigationssystem,Ledersitze,Automatik'),
('Mercedes-Benz', 'C-Klasse', 2023, 95.00, 'available', 'Elegante Business-Limousine', 'Klimaanlage,Navigationssystem,Sitzheizung,Automatik'),
('Volkswagen', 'Golf', 2021, 55.00, 'available', 'Kompakter und zuverlässiger Allrounder', 'Klimaanlage,Radio,Bluetooth,Schaltgetriebe'),
('Audi', 'A4', 2022, 85.00, 'available', 'Premium-Limousine mit Sportcharakter', 'Klimaanlage,Navigationssystem,Ledersitze,Automatik'),
('Ford', 'Focus', 2020, 45.00, 'available', 'Praktischer Kompaktwagen', 'Klimaanlage,Radio,Bluetooth,Schaltgetriebe'),
('Opel', 'Astra', 2021, 50.00, 'available', 'Komfortabler Mittelklassewagen', 'Klimaanlage,Radio,Bluetooth,Schaltgetriebe'),
('Tesla', 'Model 3', 2023, 120.00, 'available', 'Elektrisches Fahrzeug mit Autopilot', 'Klimaanlage,Navigationssystem,Autopilot,Elektrisch'),
('Porsche', '911', 2023, 250.00, 'available', 'Sportlicher Luxuswagen', 'Klimaanlage,Navigationssystem,Ledersitze,Automatik,Sportpaket'),
('Mini', 'Cooper', 2022, 65.00, 'available', 'Stylischer Kleinwagen', 'Klimaanlage,Radio,Bluetooth,Schaltgetriebe'),
('Renault', 'Clio', 2020, 40.00, 'available', 'Günstiger Kleinwagen für die Stadt', 'Klimaanlage,Radio,Schaltgetriebe');

-- ============================================
-- Seed Data: Beispiel-Buchungen
-- ============================================
INSERT INTO bookings (user_id, car_id, start_date, end_date, total_price, status) VALUES
(2, 1, '2025-01-10', '2025-01-15', 449.95, 'confirmed'),
(3, 3, '2025-01-12', '2025-01-14', 110.00, 'confirmed'),
(4, 7, '2025-01-20', '2025-01-25', 600.00, 'pending'),
(5, 5, '2024-12-15', '2024-12-20', 225.00, 'completed'),
(2, 4, '2024-12-01', '2024-12-05', 340.00, 'completed');

-- ============================================
-- Ansichten (Views) für einfachere Abfragen
-- ============================================

-- View: Aktive Buchungen mit Benutzer- und Auto-Details
CREATE VIEW active_bookings AS
SELECT 
    b.id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    u.username,
    u.email,
    c.brand,
    c.model,
    c.year,
    DATEDIFF(b.end_date, b.start_date) as rental_days
FROM bookings b
JOIN users u ON b.user_id = u.id
JOIN cars c ON b.car_id = c.id
WHERE b.status IN ('pending', 'confirmed');

-- View: Verfügbare Autos
CREATE VIEW available_cars AS
SELECT 
    id,
    brand,
    model,
    year,
    price_per_day,
    image,
    description,
    features
FROM cars
WHERE status = 'available';

-- ============================================
-- Stored Procedures
-- ============================================

-- Prozedur: Verfügbarkeit eines Autos prüfen
DELIMITER //
CREATE PROCEDURE check_car_availability(
    IN p_car_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    OUT p_is_available BOOLEAN
)
BEGIN
    DECLARE booking_count INT;
    
    SELECT COUNT(*) INTO booking_count
    FROM bookings
    WHERE car_id = p_car_id
    AND status IN ('pending', 'confirmed')
    AND (
        (p_start_date BETWEEN start_date AND end_date)
        OR (p_end_date BETWEEN start_date AND end_date)
        OR (start_date BETWEEN p_start_date AND p_end_date)
    );
    
    SET p_is_available = (booking_count = 0);
END //
DELIMITER ;

-- ============================================
-- Trigger
-- ============================================

-- Trigger: Auto-Status aktualisieren bei Buchung
DELIMITER //
CREATE TRIGGER update_car_status_after_booking
AFTER INSERT ON bookings
FOR EACH ROW
BEGIN
    IF NEW.status = 'confirmed' THEN
        UPDATE cars 
        SET status = 'rented' 
        WHERE id = NEW.car_id;
    END IF;
END //
DELIMITER ;

-- Trigger: Auto-Status zurücksetzen bei Buchungsabschluss
DELIMITER //
CREATE TRIGGER update_car_status_after_booking_update
AFTER UPDATE ON bookings
FOR EACH ROW
BEGIN
    IF NEW.status IN ('completed', 'cancelled') AND OLD.status IN ('pending', 'confirmed') THEN
        UPDATE cars 
        SET status = 'available' 
        WHERE id = NEW.car_id;
    END IF;
END //
DELIMITER ;



-- ============================================
-- Ende des Schemas
-- ============================================
