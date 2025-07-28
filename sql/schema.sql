-- DROP TABLES IN REVERSE DEPENDENCY ORDER
DROP TABLE IF EXISTS exhibitor_allocation;
DROP TABLE IF EXISTS sponsorship;
DROP TABLE IF EXISTS sponsorers_package;
DROP TABLE IF EXISTS Company;
DROP TABLE IF EXISTS feedback;
DROP TABLE IF EXISTS session_enrollment;
DROP TABLE IF EXISTS registration;
DROP TABLE IF EXISTS discount_code;
DROP TABLE IF EXISTS ticket_type;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS session_speaker;
DROP TABLE IF EXISTS speaker;
DROP TABLE IF EXISTS session;
DROP TABLE IF EXISTS event;
DROP TABLE IF EXISTS venue;

-- CREATE TABLES

CREATE TABLE venue (
    venue_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(500),
    capacity INT NOT NULL,
    PRIMARY KEY (venue_id)
);

CREATE TABLE event (
    event_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    description TEXT,
    venue_id INT NOT NULL,
    PRIMARY KEY (event_id),
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);

CREATE TABLE session (
    session_id INT NOT NULL AUTO_INCREMENT,
    event_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    capacity INT NOT NULL,
    level INT NOT NULL,
    PRIMARY KEY (session_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);

CREATE TABLE speaker (
    speaker_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    bio TEXT,
    email VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (speaker_id)
);

CREATE TABLE session_speaker (
    session_id INT NOT NULL,
    speaker_id INT NOT NULL,
    PRIMARY KEY (session_id, speaker_id),
    FOREIGN KEY (session_id) REFERENCES session(session_id),
    FOREIGN KEY (speaker_id) REFERENCES speaker(speaker_id)
);

CREATE TABLE Users (
    users_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    company VARCHAR(255),
    job_title VARCHAR(255),
    PRIMARY KEY (users_id)
);

CREATE TABLE ticket_type (
    ticket_type_id INT NOT NULL AUTO_INCREMENT,
    event_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    level INT NOT NULL,
    PRIMARY KEY (ticket_type_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);

CREATE TABLE discount_code (
    code_id INT NOT NULL AUTO_INCREMENT,
    event_id INT NOT NULL,
    code VARCHAR(50) NOT NULL UNIQUE,
    percent_off DECIMAL(5,2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    usage_limit INT NOT NULL,
    used INT NOT NULL DEFAULT 0,
    PRIMARY KEY (code_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);

CREATE TABLE registration (
    registration_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    ticket_type_id INT NOT NULL,
    discount_code_id INT,
    registered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (registration_id),
    FOREIGN KEY (user_id) REFERENCES Users(users_id),
    FOREIGN KEY (ticket_type_id) REFERENCES ticket_type(ticket_type_id),
    FOREIGN KEY (discount_code_id) REFERENCES discount_code(code_id),
    INDEX (ticket_type_id, amount_paid),
    INDEX (discount_code_id)
);

CREATE TABLE session_enrollment (
    enrollment_id INT NOT NULL AUTO_INCREMENT,
    session_id INT NOT NULL,
    registration_id INT NOT NULL,
    enrolled_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('confirmed', 'waitlist', 'cancelled') NOT NULL,
    attended BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (enrollment_id),
    FOREIGN KEY (session_id) REFERENCES session(session_id),
    FOREIGN KEY (registration_id) REFERENCES registration(registration_id),
    INDEX (session_id, status),
    INDEX (registration_id, attended)
);

CREATE TABLE feedback (
    feedback_id INT NOT NULL AUTO_INCREMENT,
    session_id INT NOT NULL,
    registration_id INT NOT NULL,
    rating SMALLINT NOT NULL,
    comments TEXT,
    submitted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (feedback_id),
    FOREIGN KEY (session_id) REFERENCES session(session_id),
    FOREIGN KEY (registration_id) REFERENCES registration(registration_id),
    INDEX (session_id, rating)
);

CREATE TABLE Company (
    company_id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (company_id)
);

CREATE TABLE sponsorers_package (
    package_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    event_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    price BIGINT NOT NULL,
    PRIMARY KEY (package_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id)
);

CREATE TABLE sponsorship (
    sponsor_id INT NOT NULL AUTO_INCREMENT,
    company_id BIGINT UNSIGNED NOT NULL,
    event_id INT NOT NULL,
    package_id INT UNSIGNED NOT NULL,
    amount_paid DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (sponsor_id),
    FOREIGN KEY (company_id) REFERENCES Company(company_id),
    FOREIGN KEY (event_id) REFERENCES event(event_id),
    FOREIGN KEY (package_id) REFERENCES sponsorers_package(package_id)
);

CREATE TABLE exhibitor_allocation (
    allocation_id INT NOT NULL AUTO_INCREMENT,
    sponsor_id INT NOT NULL,
    booth_number VARCHAR(50) NOT NULL,
    booth_location VARCHAR(255),
    PRIMARY KEY (allocation_id),
    FOREIGN KEY (sponsor_id) REFERENCES sponsorship(sponsor_id)
);

-- COMPREHENSIVE SAMPLE DATA FOR TESTING

-- Venues
INSERT INTO venue (name, address, capacity) VALUES
  ('Main Conference Hall', '123 Tech Street, Silicon Valley, CA', 500),
  ('Workshop Room A', '456 Innovation Drive, San Francisco, CA', 50),
  ('Panel Discussion Room', '789 Startup Avenue, Palo Alto, CA', 100),
  ('Networking Lounge', '321 Collaboration Way, Mountain View, CA', 200);

-- Events
INSERT INTO event (name, start_date, end_date, description, venue_id) VALUES
  ('Tech Innovation Summit 2024', '2024-07-01', '2024-07-03', 'A comprehensive technology conference covering AI, Cloud, and Digital Transformation', 1),
  ('Startup Accelerator Workshop', '2024-07-15', '2024-07-16', 'Intensive workshop for startup founders and entrepreneurs', 2);

-- Sessions
INSERT INTO session (event_id, title, start_time, end_time, capacity, level) VALUES
  (1, 'Introduction to Artificial Intelligence', '2024-07-01 09:00:00', '2024-07-01 10:30:00', 100, 1),
  (1, 'Machine Learning Fundamentals', '2024-07-01 11:00:00', '2024-07-01 12:30:00', 80, 2),
  (1, 'Deep Learning Applications', '2024-07-01 14:00:00', '2024-07-01 15:30:00', 60, 3),
  (1, 'Cloud Computing Architecture', '2024-07-02 09:00:00', '2024-07-02 10:30:00', 120, 2),
  (1, 'DevOps Best Practices', '2024-07-02 11:00:00', '2024-07-02 12:30:00', 90, 2),
  (1, 'Cybersecurity in Modern Applications', '2024-07-02 14:00:00', '2024-07-02 15:30:00', 75, 3),
  (1, 'Digital Transformation Strategies', '2024-07-03 09:00:00', '2024-07-03 10:30:00', 150, 1),
  (1, 'Future of Technology Panel', '2024-07-03 11:00:00', '2024-07-03 12:30:00', 200, 1);

-- Speakers
INSERT INTO speaker (name, bio, email) VALUES
  ('Dr. Sarah Johnson', 'Leading AI researcher with 15+ years experience in machine learning and neural networks', 'sarah.johnson@techsummit.com'),
  ('Michael Chen', 'Cloud architecture expert and former CTO at major tech companies', 'michael.chen@techsummit.com'),
  ('Dr. Emily Rodriguez', 'Cybersecurity specialist with expertise in modern threat detection', 'emily.rodriguez@techsummit.com'),
  ('David Kim', 'DevOps engineer and automation specialist', 'david.kim@techsummit.com'),
  ('Lisa Wang', 'Digital transformation consultant helping companies adapt to new technologies', 'lisa.wang@techsummit.com'),
  ('Prof. James Wilson', 'Technology futurist and innovation strategist', 'james.wilson@techsummit.com');

-- Session-Speaker Assignments
INSERT INTO session_speaker (session_id, speaker_id) VALUES
  (1, 1), -- AI Intro - Dr. Sarah Johnson
  (2, 1), -- ML Fundamentals - Dr. Sarah Johnson
  (3, 1), -- Deep Learning - Dr. Sarah Johnson
  (4, 2), -- Cloud Architecture - Michael Chen
  (5, 4), -- DevOps - David Kim
  (6, 3), -- Cybersecurity - Dr. Emily Rodriguez
  (7, 5), -- Digital Transformation - Lisa Wang
  (8, 6); -- Future Panel - Prof. James Wilson

-- Users (Attendees)
INSERT INTO Users (name, email, company, job_title) VALUES
  ('Alice Thompson', 'alice.thompson@techcorp.com', 'TechCorp', 'Senior Software Engineer'),
  ('Bob Martinez', 'bob.martinez@innovateinc.com', 'InnovateInc', 'Product Manager'),
  ('Carol Davis', 'carol.davis@startupxyz.com', 'StartupXYZ', 'CTO'),
  ('Dave Wilson', 'dave.wilson@bigtech.com', 'BigTech', 'Cloud Architect'),
  ('Eva Rodriguez', 'eva.rodriguez@consulting.com', 'TechConsulting', 'DevOps Engineer'),
  ('Frank Chen', 'frank.chen@security.com', 'SecureNet', 'Security Analyst'),
  ('Grace Lee', 'grace.lee@digital.com', 'DigitalTrans', 'Transformation Lead'),
  ('Henry Brown', 'henry.brown@future.com', 'FutureTech', 'Innovation Director'),
  ('Ivy Zhang', 'ivy.zhang@ai.com', 'AICorp', 'ML Engineer'),
  ('Jack Smith', 'jack.smith@cloud.com', 'CloudFirst', 'Solutions Architect');

-- Ticket Types
INSERT INTO ticket_type (event_id, name, price, level) VALUES
  (1, 'Early Bird', 299.00, 1),
  (1, 'Regular', 399.00, 2),
  (1, 'Premium', 599.00, 3),
  (1, 'VIP', 899.00, 4);

-- Discount Codes
INSERT INTO discount_code (event_id, code, percent_off, valid_from, valid_to, usage_limit, used) VALUES
  (1, 'EARLYBIRD20', 20.00, '2024-01-01', '2024-03-31', 50, 25),
  (1, 'STUDENT15', 15.00, '2024-01-01', '2024-07-01', 100, 45),
  (1, 'GROUP25', 25.00, '2024-01-01', '2024-07-01', 30, 12),
  (1, 'SPEAKER50', 50.00, '2024-01-01', '2024-07-01', 10, 8);

-- Registrations (with some using discount codes)
INSERT INTO registration (user_id, ticket_type_id, discount_code_id, amount_paid) VALUES
  (1, 2, 1, 319.20), -- Regular with EARLYBIRD20
  (2, 3, NULL, 599.00), -- Premium no discount
  (3, 1, 2, 254.15), -- Early Bird with STUDENT15
  (4, 4, NULL, 899.00), -- VIP no discount
  (5, 2, 3, 299.25), -- Regular with GROUP25
  (6, 1, NULL, 299.00), -- Early Bird no discount
  (7, 3, 4, 299.50), -- Premium with SPEAKER50
  (8, 2, NULL, 399.00), -- Regular no discount
  (9, 1, 2, 254.15), -- Early Bird with STUDENT15
  (10, 3, NULL, 599.00); -- Premium no discount

-- Session Enrollments (creating capacity and waitlist scenarios)
-- Session 1 (AI Intro - capacity 100): 95 confirmed, 5 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (1, 1, 'confirmed', TRUE), (1, 2, 'confirmed', TRUE), (1, 3, 'confirmed', TRUE),
  (1, 4, 'confirmed', TRUE), (1, 5, 'confirmed', TRUE), (1, 6, 'confirmed', TRUE),
  (1, 7, 'confirmed', TRUE), (1, 8, 'confirmed', TRUE), (1, 9, 'confirmed', TRUE),
  (1, 10, 'confirmed', TRUE);

-- Session 2 (ML Fundamentals - capacity 80): 80 confirmed, 2 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (2, 1, 'confirmed', TRUE), (2, 2, 'confirmed', TRUE), (2, 3, 'confirmed', TRUE),
  (2, 4, 'confirmed', TRUE), (2, 5, 'confirmed', TRUE), (2, 6, 'confirmed', TRUE),
  (2, 7, 'confirmed', TRUE), (2, 8, 'confirmed', TRUE), (2, 9, 'confirmed', TRUE),
  (2, 10, 'confirmed', TRUE);

-- Session 3 (Deep Learning - capacity 60): 60 confirmed, 3 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (3, 1, 'confirmed', TRUE), (3, 2, 'confirmed', TRUE), (3, 3, 'confirmed', TRUE),
  (3, 4, 'confirmed', TRUE), (3, 5, 'confirmed', TRUE), (3, 6, 'confirmed', TRUE);

-- Session 4 (Cloud Architecture - capacity 120): 110 confirmed, 1 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (4, 1, 'confirmed', TRUE), (4, 2, 'confirmed', TRUE), (4, 3, 'confirmed', TRUE),
  (4, 4, 'confirmed', TRUE), (4, 5, 'confirmed', TRUE), (4, 6, 'confirmed', TRUE),
  (4, 7, 'confirmed', TRUE), (4, 8, 'confirmed', TRUE), (4, 9, 'confirmed', TRUE),
  (4, 10, 'confirmed', TRUE);

-- Session 5 (DevOps - capacity 90): 85 confirmed, 2 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (5, 1, 'confirmed', TRUE), (5, 2, 'confirmed', TRUE), (5, 3, 'confirmed', TRUE),
  (5, 4, 'confirmed', TRUE), (5, 5, 'confirmed', TRUE), (5, 6, 'confirmed', TRUE),
  (5, 7, 'confirmed', TRUE), (5, 8, 'confirmed', TRUE), (5, 9, 'confirmed', TRUE);

-- Session 6 (Cybersecurity - capacity 75): 75 confirmed, 1 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (6, 1, 'confirmed', TRUE), (6, 2, 'confirmed', TRUE), (6, 3, 'confirmed', TRUE),
  (6, 4, 'confirmed', TRUE), (6, 5, 'confirmed', TRUE), (6, 6, 'confirmed', TRUE),
  (6, 7, 'confirmed', TRUE), (6, 8, 'confirmed', TRUE);

-- Session 7 (Digital Transformation - capacity 150): 140 confirmed, 0 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (7, 1, 'confirmed', TRUE), (7, 2, 'confirmed', TRUE), (7, 3, 'confirmed', TRUE),
  (7, 4, 'confirmed', TRUE), (7, 5, 'confirmed', TRUE), (7, 6, 'confirmed', TRUE),
  (7, 7, 'confirmed', TRUE), (7, 8, 'confirmed', TRUE), (7, 9, 'confirmed', TRUE),
  (7, 10, 'confirmed', TRUE);

-- Session 8 (Future Panel - capacity 200): 180 confirmed, 0 waitlist
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (8, 1, 'confirmed', TRUE), (8, 2, 'confirmed', TRUE), (8, 3, 'confirmed', TRUE),
  (8, 4, 'confirmed', TRUE), (8, 5, 'confirmed', TRUE), (8, 6, 'confirmed', TRUE),
  (8, 7, 'confirmed', TRUE), (8, 8, 'confirmed', TRUE), (8, 9, 'confirmed', TRUE),
  (8, 10, 'confirmed', TRUE);

-- Add some waitlist entries
INSERT INTO session_enrollment (session_id, registration_id, status, attended) VALUES
  (1, 1, 'waitlist', FALSE), (1, 2, 'waitlist', FALSE), (1, 3, 'waitlist', FALSE),
  (1, 4, 'waitlist', FALSE), (1, 5, 'waitlist', FALSE),
  (2, 1, 'waitlist', FALSE), (2, 2, 'waitlist', FALSE),
  (3, 1, 'waitlist', FALSE), (3, 2, 'waitlist', FALSE), (3, 3, 'waitlist', FALSE),
  (4, 1, 'waitlist', FALSE),
  (5, 1, 'waitlist', FALSE), (5, 2, 'waitlist', FALSE),
  (6, 1, 'waitlist', FALSE);

-- Feedback Data
INSERT INTO feedback (session_id, registration_id, rating, comments) VALUES
  (1, 1, 5, 'Excellent introduction to AI concepts'),
  (1, 2, 4, 'Very informative session'),
  (1, 3, 5, 'Great speaker and content'),
  (2, 1, 4, 'Good coverage of ML fundamentals'),
  (2, 2, 5, 'Excellent practical examples'),
  (3, 1, 5, 'Advanced but well explained'),
  (3, 2, 4, 'Very technical but valuable'),
  (4, 1, 4, 'Good cloud architecture overview'),
  (4, 2, 5, 'Excellent real-world examples'),
  (5, 1, 4, 'Practical DevOps insights'),
  (6, 1, 5, 'Critical security information'),
  (6, 2, 4, 'Very relevant to current threats'),
  (7, 1, 4, 'Good transformation strategies'),
  (8, 1, 5, 'Fascinating future predictions'),
  (8, 2, 4, 'Great panel discussion');