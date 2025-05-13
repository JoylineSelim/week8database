📚 Library Management System
📖 Project Overview
This Library Management System is a comprehensive relational database solution built using MySQL to manage the core operations of a modern library. It facilitates the management of books, members, staff, loans, reservations, and fines. The system ensures efficient data integrity and smooth workflow for library operations.

🗂️ Database Schema
🧱 Tables Structure
Table	Description
Members	Stores information about library members including contact details and membership dates.
Authors	Contains author details, including names and biographies.
Publishers	Maintains records of book publishers.
Books	Central catalog of all library materials including status and classification.
Book_Authors	Junction table for many-to-many relationship between books and authors.
Loans	Tracks book checkouts and returns, due dates, and loan status.
Fines	Manages overdue fines, payment statuses, and waivers.
Reservations	Handles the reservation system for books by members.
Staff	Contains information on library employees and their roles.

🚀 Key Features
📚 Comprehensive Book Tracking
Supports multiple copies of a single book.

Tracks availability status of each book.

Enables detailed categorization and classification.

👥 Member Management
Tracks membership status (active/inactive).

Stores contact information and date joined.

Manages borrowing history and account status.

🔁 Loan System
Records check-in/check-out history.

Calculates due dates and monitors overdue items.

Links each loan to the responsible staff and member.

💰 Financial Tracking
Automatically computes fines for late returns.

Maintains payment status (paid/unpaid).

Includes options for fine waivers and manual overrides.

✅ Technologies Used
MySQL – Database design and management

SQL – Queries and data manipulation

Drawio- Entity Relationship Diagram
📎 How to Use
Clone the repository or import the .sql file into your MySQL database.

Review the CREATE TABLE statements and modify if needed.

Populate the database with seed data for testing.

Integrate with a frontend or API as required.


