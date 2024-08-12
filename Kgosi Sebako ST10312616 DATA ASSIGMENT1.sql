-- Create Database
DROP DATABASE IF EXISTS LibraryDB;
CREATE DATABASE LibraryDB;
USE LibraryDB;

-- Create the Author table
DROP TABLE IF EXISTS Author;
CREATE TABLE Author (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Surname VARCHAR(255) NOT NULL
);

-- Create the Genre table
DROP TABLE IF EXISTS Genre;
CREATE TABLE Genre (
    GenreID INT AUTO_INCREMENT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL
);

-- Create the Book table
DROP TABLE IF EXISTS Book;
CREATE TABLE Book (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    GenreID INT,
    AuthorID INT,
    FOREIGN KEY (GenreID) REFERENCES Genre(GenreID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

-- Create the Competition table
DROP TABLE IF EXISTS Competition;
CREATE TABLE Competition (
    CompetitionID INT AUTO_INCREMENT PRIMARY KEY,
    Description VARCHAR(255) NOT NULL
);

-- Create the Entry table (associative table for many-to-many relationship between Book and Competition)
DROP TABLE IF EXISTS Entry;
CREATE TABLE Entry (
    EntryID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT,
    CompetitionID INT,
    FOREIGN KEY (BookID) REFERENCES Book(BookID),
    FOREIGN KEY (CompetitionID) REFERENCES Competition(CompetitionID)
);
-- Insert into Author table
INSERT INTO Author (Name, Surname) VALUES
('J.K.', 'Rowling'),
('George', 'Orwell'),
('J.R.R.', 'Tolkien'),
('Harper', 'Lee'),
('Jane', 'Austen');

-- Insert into Genre table
INSERT INTO Genre (Description) VALUES
('Fantasy'),
('Science Fiction'),
('Classic');

-- Insert into Book table
INSERT INTO Book (Title, GenreID, AuthorID) VALUES
('Harry Potter and the Sorcerer\'s Stone', 1, 1),
('Harry Potter and the Chamber of Secrets', 1, 1),
('Harry Potter and the Prisoner of Azkaban', 1, 1),
('1984', 2, 2),
('Animal Farm', 2, 2),
('The Hobbit', 1, 3),
('The Lord of the Rings', 1, 3),
('To Kill a Mockingbird', 3, 4),
('Pride and Prejudice', 3, 5),
('Sense and Sensibility', 3, 5),
('Emma', 3, 5),
('Mansfield Park', 3, 5),
('Northanger Abbey', 3, 5),
('Persuasion', 3, 5),
('The Silmarillion', 1, 3),
('Brave New World', 2, 2),
('Fahrenheit 451', 2, 2),
('A Clockwork Orange', 2, 2),
('The Great Gatsby', 3, 5),
('Moby Dick', 3, 5);

-- Insert into Competition table
INSERT INTO Competition (Description) VALUES
('National Book Awards'),
('Pulitzer Prize'),
('Hugo Award'),
('Nebula Award'),
('Man Booker Prize'),
('Costa Book Awards'),
('Edgar Awards'),
('Goodreads Choice Awards'),
('Nobel Prize in Literature'),
('Golden Globe Award'),
('Bram Stoker Award'),
('British Fantasy Award'),
('World Fantasy Award'),
('Dragon Award'),
('Quill Award');

-- Insert into Entry table (associating Books with Competitions)
INSERT INTO Entry (BookID, CompetitionID) VALUES
(1, 1), (1, 2), 
(2, 3),
(3, 4),
(4, 5), 
(5, 6), 
(6, 7), (6, 8),
(7, 9), 
(8, 10), 
(9, 11), 
(10, 12), 
(11, 13), 
(12, 14), 
(13, 15), 
(14, 1), 
(15, 2),
(16, 3),
(17, 4), 
(18, 5), 
(19, 6), 
(20, 7);
-- Assuming you know the AuthorID of J.K. Rowling
UPDATE Author
SET Surname = 'Rowling'
WHERE AuthorID = 1;  -- Replace 1 with the actual AuthorID of J.K. Rowling
-- Delete entries related to the competition
DELETE FROM Entry
WHERE CompetitionID = (SELECT CompetitionID FROM Competition WHERE Description = 'Golden Globe Award');

-- Now delete the competition
DELETE FROM Competition
WHERE Description = 'Golden Globe Award';
-- Display all book titles, their authors, and their genres, sorted alphabetically by genre and then by book title
SELECT 
    Book.Title AS 'Book Title',
    CONCAT(Author.Name, ' ', Author.Surname) AS 'Author',
    Genre.Description AS 'Genre'
FROM 
    Book
JOIN 
    Author ON Book.AuthorID = Author.AuthorID
JOIN 
    Genre ON Book.GenreID = Genre.GenreID
ORDER BY 
    Genre.Description ASC, 
    Book.Title ASC;
-- Count the number of books per genre
SELECT 
    Genre.Description AS 'Genre',
    COUNT(Book.BookID) AS 'Number of Books'
FROM 
    Book
JOIN 
    Genre ON Book.GenreID = Genre.GenreID
GROUP BY 
    Genre.Description;

-- Purpose: This report shows the number of books available in each genre.
-- Show genres with more than 3 books
SELECT 
    Genre.Description AS 'Genre',
    COUNT(Book.BookID) AS 'Number of Books'
FROM 
    Book
JOIN 
    Genre ON Book.GenreID = Genre.GenreID
GROUP BY 
    Genre.Description
HAVING 
    COUNT(Book.BookID) > 3;

-- Purpose: This report identifies genres that have a higher concentration of books, specifically those with more than three books.
-- Show all books that have entered competitions, including the competition name and author
SELECT 
    Book.Title AS 'Book Title',
    CONCAT(Author.Name, ' ', Author.Surname) AS 'Author',
    Competition.Description AS 'Competition'
FROM 
    Entry
JOIN 
    Book ON Entry.BookID = Book.BookID
JOIN 
    Competition ON Entry.CompetitionID = Competition.CompetitionID
JOIN 
    Author ON Book.AuthorID = Author.AuthorID
ORDER BY 
    Book.Title ASC;

-- Purpose: This report provides a list of all books that have entered competitions, along with their respective authors and competition names.
