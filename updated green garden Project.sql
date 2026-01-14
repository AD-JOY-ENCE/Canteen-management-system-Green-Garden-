CREATE DATABASE GreenGarden1;
USE GreenGarden1;

-- BRANCHES TABLE
CREATE TABLE Branches (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    location VARCHAR(150)
);

-- FLOORS TABLE
CREATE TABLE Floors (
    floor_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT,
    floor_number INT,
    purpose ENUM('food_service', 'event_space'),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- USERS TABLE
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    password VARCHAR(100),
    user_type ENUM('student', 'teacher', 'employee', 'admin')
);

-- CATEGORIES
CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50)
);

-- FOOD ITEMS
CREATE TABLE FoodItems (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(6,2),
    prep_time INT,
    availability_status ENUM('available', 'unavailable', 'discontinued'),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- ORDERS
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    branch_id INT,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(7,2),
    payment_method ENUM('cash', 'onecard'),
    status ENUM('pending', 'preparing', 'ready', 'delivered', 'canceled'),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- ORDER ITEMS
CREATE TABLE OrderItems (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES FoodItems(item_id)
);

-- LOGIN TRACKING
CREATE TABLE UserLogins (
    login_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- COMBOS
CREATE TABLE Combos (
    combo_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    price DECIMAL(6,2)
);

-- COMBO ITEMS
CREATE TABLE ComboItems (
    combo_id INT,
    item_id INT,
    PRIMARY KEY (combo_id, item_id),
    FOREIGN KEY (combo_id) REFERENCES Combos(combo_id),
    FOREIGN KEY (item_id) REFERENCES FoodItems(item_id)
);

-- EVENT BOOKINGS
CREATE TABLE EventBookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    floor_id INT,
    branch_id INT,
    event_name VARCHAR(100),
    event_date DATE,
    start_time TIME,
    end_time TIME,
    amount_paid DECIMAL(7,2),
    payment_method ENUM('cash', 'onecard'),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (floor_id) REFERENCES Floors(floor_id),
    FOREIGN KEY (branch_id) REFERENCES Branches(branch_id)
);

-- SAMPLE DATA
INSERT INTO Branches (name, location) VALUES
('Green Garden Main Campus', 'Daffodil International University'),
('Green Garden 2 ', 'Dhanmondi, Dhaka');

INSERT INTO Floors (branch_id, floor_number, purpose) VALUES
(1, 1, 'food_service'),
(1, 2, 'event_space'),
(1, 3, 'event_space'),
(2, 1, 'food_service'),
(2, 2, 'event_space'),
(2, 3, 'event_space');

INSERT INTO Users (name, email, phone, password, user_type) VALUES
('Aovinondon', 'Aovinondon@example.com', '1234567890', 'pass123', 'student'),
('Sajjad', 'sajjad@example.com', '2345678901', 'pass456', 'employee'),
('Meherab', 'meherab@example.com', '3456789012', 'adminpass', 'admin'),
('Nuhash', 'Nuhash@example.com', '4567890123', 'emilypass', 'teacher'),
('Sadia', 'sadia@example.com', '5678901234', 'davidpass', 'employee');

INSERT INTO Categories (name) VALUES
('Snacks'), ('Meals'), ('Drinks'), ('Desserts'), ('Specials');

INSERT INTO FoodItems (name, price, prep_time, availability_status, category_id) VALUES
('Porota', 120.00, 10, 'available', 1),
('Dal Sobji', 150.00, 12, 'available', 2),
('Khicuri', 80.00, 5, 'available', 3),
('Chicken', 90.00, 7, 'available', 4),
('Plain Rice', 250.00, 20, 'available', 5),
('Mix Vegetables', 250.00, 20, 'available', 2),
('Egg Fry', 250.00, 20, 'available', 5);
select * from FoodItems;
INSERT INTO Orders (user_id, branch_id, total_amount, payment_method, status) VALUES
(1, 1, 270.00, 'onecard', 'delivered'),
(4, 2, 90.00, 'cash', 'delivered'),
(1, 1, 230.00, 'onecard', 'preparing'),
(5, 2, 150.00, 'onecard', 'pending'),
(2, 1, 330.00, 'cash', 'delivered');

INSERT INTO OrderItems (order_id, item_id, quantity) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(2, 4, 1),
(3, 2, 1),
(3, 5, 1),
(4, 2, 1),
(5, 1, 2),
(5, 3, 1);

INSERT INTO UserLogins (user_id) VALUES
(1), (2), (3), (4), (5);

INSERT INTO Combos (name, price) VALUES
('Breakfast Combo', 200.00),
('Lunch Combo', 250.00),
('Dessert Combo', 180.00);

INSERT INTO ComboItems (combo_id, item_id) VALUES
(1, 1), (1, 3),
(2, 2), (2, 5),
(3, 4);

INSERT INTO EventBookings (user_id, floor_id, branch_id, event_name, event_date, start_time, end_time, amount_paid, payment_method) VALUES
(4, 2, 1, 'Science Club Meet', '2025-04-10', '10:00:00', '12:00:00', 500.00, 'cash'),
(1, 5, 2, 'Drama Rehearsal', '2025-04-11', '14:00:00', '17:00:00', 600.00, 'card');

-- SAMPLE QUERIES

-- 1. Join query to show order details with items
SELECT o.order_id, u.name AS customer, fi.name AS item, oi.quantity, o.total_amount, b.name AS branch
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN FoodItems fi ON oi.item_id = fi.item_id
JOIN Branches b ON o.branch_id = b.branch_id;

-- 2. Aggregate query to count total orders
SELECT COUNT(*) AS total_orders FROM Orders;

-- 3. Aggregate query to show  total amounts
SELECT SUM(total_amount) AS total_food_earnings FROM Orders;

SELECT SUM(amount_paid) AS total_event_earnings FROM EventBookings;

-- 4. Count of food items per category
SELECT c.name AS category, COUNT(f.item_id) AS total_items
FROM Categories c
LEFT JOIN FoodItems f ON c.category_id = f.category_id
GROUP BY c.name;




