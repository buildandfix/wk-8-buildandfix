-- Library Management System Database
-- Designed to manage books, authors, members, loans, and categories
-- Uses MySQL with proper constraints and relationships

-- Create categories table (stores book categories)
CREATE TABLE categories (
    categoryID INT AUTO_INCREMENT PRIMARY KEY,
    categoryName VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- Create authors table (stores author details)
CREATE TABLE authors (
    authorID INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    birthYear INT,
    CONSTRAINT chk_birthYear CHECK (birthYear > 1800 AND birthYear <= YEAR(CURDATE()))
);

-- Create books table (stores book details)
CREATE TABLE books (
    bookID INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    isbn VARCHAR(13) NOT NULL UNIQUE,
    publicationYear INT NOT NULL,
    categoryID INT NOT NULL,
    totalCopies INT NOT NULL DEFAULT 1,
    availableCopies INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_publicationYear CHECK (publicationYear > 1800 AND publicationYear <= YEAR(CURDATE())),
    CONSTRAINT chk_copies CHECK (availableCopies <= totalCopies AND availableCopies >= 0),
    CONSTRAINT fk_books_category FOREIGN KEY (categoryID) 
        REFERENCES categories(categoryID) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Create book_authors table (junction table for books-authors many-to-many relationship)
CREATE TABLE book_authors (
    bookID INT,
    authorID INT,
    PRIMARY KEY (bookID, authorID),
    CONSTRAINT fk_book_authors_book FOREIGN KEY (bookID) 
        REFERENCES books(bookID) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_book_authors_author FOREIGN KEY (authorID) 
        REFERENCES authors(authorID) 
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create members table (stores library member details)
CREATE TABLE members (
    memberID INT AUTO_INCREMENT PRIMARY KEY,
    firstName VARCHAR(50) NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    joinDate DATE NOT NULL DEFAULT (CURDATE()),
    phone VARCHAR(15),
    CONSTRAINT chk_email CHECK (email LIKE '%@%.%')
);

-- Create loans table (stores book loan records)
CREATE TABLE loans (
    loanID INT AUTO_INCREMENT PRIMARY KEY,
    bookID INT NOT NULL,
    memberID INT NOT NULL,
    loanDate DATE NOT NULL DEFAULT (CURDATE()),
    returnDate DATE,
    status ENUM('Active', 'Returned', 'Overdue') NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_loans_book FOREIGN KEY (bookID) 
        REFERENCES books(bookID) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_loans_member FOREIGN KEY (memberID) 
        REFERENCES members(memberID) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_dates CHECK (returnDate IS NULL OR returnDate >= loanDate)
);

-- Insert sample data for testing
INSERT INTO categories (categoryName, description) VALUES
('Fiction', 'Fictional literature'),
('Non-Fiction', 'Factual and informational books'),
('Science Fiction', 'Speculative fiction with futuristic themes');

INSERT INTO authors (firstName, lastName, birthYear) VALUES
('J.K.', 'Rowling', 1965),
('Isaac', 'Asimov', 1920),
('Jane', 'Austen', 1775);

INSERT INTO books (title, isbn, publicationYear, categoryID, totalCopies, availableCopies) VALUES
('Harry Potter and the Sorcerer''s Stone', '9780590353427', 1997, 1, 5, 3),
('Foundation', '9780553293357', 1951, 3, 3, 2),
('Pride and Prejudice', '9780141439518', 1813, 1, 4, 4);

INSERT INTO book_authors (bookID, authorID) VALUES
(1, 1), -- Harry Potter by J.K. Rowling
(2, 2), -- Foundation by Isaac Asimov
(3, 3); -- Pride and Prejudice by Jane Austen

INSERT INTO members (firstName, lastName, email, joinDate, phone) VALUES
('John', 'Doe', 'john.doe@example.com', '2025-01-01', '555-0101'),
('Jane', 'Smith', 'jane.smith@example.com', '2025-02-15', '555-0102');

INSERT INTO loans (bookID, memberID, loanDate, returnDate, status) VALUES
(1, 1, '2025-05-01', NULL, 'Active'),
(2, 2, '2025-05-10', '2025-05-12', 'Returned');