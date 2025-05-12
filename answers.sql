-- Library Management System Database
-- Created by [Your Name]
-- Date: [Current Date]

-- Create database
DROP DATABASE IF EXISTS library_management;
CREATE DATABASE library_management;
USE library_management;

-- Members table
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(200),
    date_of_birth DATE,
    membership_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    membership_status ENUM('Active', 'Expired', 'Suspended') NOT NULL DEFAULT 'Active',
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Authors table
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    biography TEXT,
    nationality VARCHAR(50)
);

-- Publishers table
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(200),
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(100)
);

-- Books table
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    isbn VARCHAR(20) UNIQUE NOT NULL,
    publisher_id INT,
    publication_year INT,
    edition INT,
    category VARCHAR(50),
    language VARCHAR(30),
    page_count INT,
    description TEXT,
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    shelf_location VARCHAR(20),
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL,
    CONSTRAINT chk_publication_year CHECK (publication_year BETWEEN 1000 AND YEAR(CURRENT_DATE) + 5),
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies AND total_copies >= 0 AND available_copies >= 0)
);

-- Book-Author relationship (Many-to-Many)
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Loans table
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('On Loan', 'Returned', 'Overdue', 'Lost') NOT NULL DEFAULT 'On Loan',
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE RESTRICT,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE RESTRICT,
    CONSTRAINT chk_due_date CHECK (due_date > loan_date),
    CONSTRAINT chk_return_date CHECK (return_date IS NULL OR return_date >= loan_date)
);

-- Fines table
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    loan_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    issue_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    payment_date DATE,
    status ENUM('Pending', 'Paid', 'Waived') NOT NULL DEFAULT 'Pending',
    reason VARCHAR(200) NOT NULL,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE CASCADE,
    CONSTRAINT chk_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_date CHECK (payment_date IS NULL OR payment_date >= issue_date)
);

-- Reservations table
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Fulfilled', 'Cancelled') NOT NULL DEFAULT 'Pending',
    notification_date DATETIME,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    CONSTRAINT unique_active_reservation UNIQUE (book_id, member_id, status) WHERE (status = 'Pending')
);

-- Staff table
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    position VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL DEFAULT (CURRENT_DATE),
    salary DECIMAL(10,2),
    CONSTRAINT chk_salary CHECK (salary > 0)
);

-- Insert sample data into members
INSERT INTO members (first_name, last_name, email, phone, address, date_of_birth, membership_status) VALUES
('John', 'Smith', 'john.smith@email.com', '555-0101', '123 Main St, Anytown', '1985-07-15', 'Active'),
('Emily', 'Johnson', 'emily.j@email.com', '555-0102', '456 Oak Ave, Somewhere', '1992-03-22', 'Active'),
('Michael', 'Williams', 'michael.w@email.com', '555-0103', '789 Pine Rd, Nowhere', '1978-11-30', 'Active'),
('Sarah', 'Brown', 'sarah.b@email.com', '555-0104', '321 Elm St, Anywhere', '1995-05-18', 'Suspended'),
('David', 'Jones', 'david.j@email.com', NULL, '654 Maple Dr, Everywhere', '1982-09-25', 'Expired');

-- Insert sample data into publishers
INSERT INTO publishers (name, address, phone, email, website) VALUES
('Penguin Random House', '1745 Broadway, New York, NY', '212-782-9000', 'info@penguinrandomhouse.com', 'www.penguinrandomhouse.com'),
('HarperCollins', '195 Broadway, New York, NY', '212-207-7000', 'contact@harpercollins.com', 'www.harpercollins.com'),
('Simon & Schuster', '1230 Avenue of the Americas, New York, NY', '212-698-7000', 'inquiries@simonandschuster.com', 'www.simonandschuster.com');

-- Insert sample data into authors
INSERT INTO authors (first_name, last_name, biography, nationality) VALUES
('George', 'Orwell', 'English novelist, essayist, journalist and critic', 'British'),
('J.K.', 'Rowling', 'British author best known for the Harry Potter series', 'British'),
('Stephen', 'King', 'American author of horror, supernatural fiction, suspense, and fantasy novels', 'American'),
('Agatha', 'Christie', 'English writer known for her detective novels', 'British'),
('Ernest', 'Hemingway', 'American novelist, short-story writer, and journalist', 'American');

-- Insert sample data into books
INSERT INTO books (title, isbn, publisher_id, publication_year, edition, category, language, page_count, description, total_copies, available_copies, shelf_location) VALUES
('1984', '9780451524935', 1, 1949, 1, 'Dystopian', 'English', 328, 'A dystopian social science fiction novel', 5, 3, 'A12'),
('Animal Farm', '9780451526342', 1, 1945, 1, 'Political Satire', 'English', 112, 'An allegorical novella', 3, 2, 'A13'),
('Harry Potter and the Philosopher''s Stone', '9780747532743', 2, 1997, 1, 'Fantasy', 'English', 223, 'First novel in the Harry Potter series', 7, 5, 'B05'),
('The Shining', '9780307743657', 3, 1977, 1, 'Horror', 'English', 447, 'A horror novel about a haunted hotel', 4, 4, 'C22'),
('Murder on the Orient Express', '9780062693662', 2, 1934, 1, 'Mystery', 'English', 256, 'A detective novel featuring Hercule Poirot', 2, 1, 'D07');

-- Insert book-author relationships
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- 1984 by George Orwell
(2, 1), -- Animal Farm by George Orwell
(3, 2), -- Harry Potter by J.K. Rowling
(4, 3), -- The Shining by Stephen King
(5, 4); -- Murder on the Orient Express by Agatha Christie

-- Insert sample data into loans
INSERT INTO loans (book_id, member_id, loan_date, due_date, return_date, status) VALUES
(1, 1, '2023-05-01', '2023-05-15', '2023-05-14', 'Returned'),
(2, 2, '2023-05-10', '2023-05-24', NULL, 'Overdue'),
(3, 3, '2023-06-01', '2023-06-15', NULL, 'On Loan'),
(1, 4, '2023-06-05', '2023-06-19', NULL, 'On Loan'),
(5, 1, '2023-06-10', '2023-06-24', NULL, 'On Loan');

-- Insert sample data into fines
INSERT INTO fines (loan_id, amount, payment_date, status, reason) VALUES
(2, 5.50, NULL, 'Pending', 'Overdue book'),
(1, 2.00, '2023-05-15', 'Paid', 'Late return (1 day)');

-- Insert sample data into reservations
INSERT INTO reservations (book_id, member_id, reservation_date, status, notification_date) VALUES
(1, 3, '2023-06-01 10:30:00', 'Fulfilled', '2023-06-05 09:15:00'),
(3, 2, '2023-06-10 14:45:00', 'Pending', NULL),
(5, 4, '2023-06-05 11:20:00', 'Cancelled', NULL);

-- Insert sample data into staff
INSERT INTO staff (first_name, last_name, email, phone, position, hire_date, salary) VALUES
('Robert', 'Wilson', 'r.wilson@library.org', '555-0201', 'Librarian', '2020-01-15', 45000.00),
('Jennifer', 'Davis', 'j.davis@library.org', '555-0202', 'Assistant Librarian', '2021-03-22', 38000.00),
('Thomas', 'Miller', 't.miller@library.org', '555-0203', 'IT Specialist', '2019-11-10', 52000.00);

-- Update book available copies based on loans
UPDATE books b
SET available_copies = b.total_copies - (
    SELECT COUNT(*) 
    FROM loans l 
    WHERE l.book_id = b.book_id AND l.status IN ('On Loan', 'Overdue')
WHERE book_id IN (1, 2, 3, 4, 5);
