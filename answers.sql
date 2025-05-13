
-- Question 1: Transform ProductDetail table into 1NF
-- Original table has multiple products in a single column, violating 1NF
-- Create a new table with one product per row, ensuring atomic values

-- Step 1: Create the new 1NF table
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    PRIMARY KEY (OrderID, Product)
);

-- Step 2: Insert data, splitting the Products column (assuming PostgreSQL with UNNEST)
INSERT INTO ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT 
    OrderID,
    CustomerName,
    TRIM(UNNEST(STRING_TO_ARRAY(Products, ','))) AS Product
FROM ProductDetail;

-- Question 2: Transform OrderDetails table into 2NF
-- Original table has partial dependency (CustomerName depends only on OrderID)
-- Split into Orders (OrderID, CustomerName) and OrderItems (OrderID, Product, Quantity)

-- Step 1: Create Orders table for OrderID and CustomerName
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

-- Step 2: Create OrderItems table for OrderID, Product, and Quantity
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(50),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Insert unique OrderID and CustomerName into Orders
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 4: Insert OrderID, Product, and Quantity into OrderItems
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;