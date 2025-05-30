

CREATE TABLE Item (
	ItemName VARCHAR (30) NOT NULL,
  ItemType CHAR(1) NOT NULL,
  ItemColour VARCHAR(10),
  PRIMARY KEY (ItemName));

CREATE TABLE Employee (
  EmployeeNumber SMALLINT NOT NULL ,
  EmployeeName VARCHAR(10) NOT NULL ,
  EmployeeSalary INTEGER NOT NULL ,
  DepartmentName VARCHAR(10) NOT NULL,
  BossNumber SMALLINT NOT NULL,
  PRIMARY KEY (EmployeeNumber),
  FOREIGN KEY (DepartmentName) REFERENCES Department(DepartmentName),
  FOREIGN KEY (BossNumber) REFERENCES Employee(EmployeeNumber));

CREATE TABLE Department (
  DepartmentName VARCHAR(10) NOT NULL,
  DepartmentFloor SMALLINT NOT NULL,
  DepartmentPhone SMALLINT NOT NULL,
  EmployeeNumber SMALLINT NOT NULL,
  PRIMARY KEY (DepartmentName),
  FOREIGN KEY (EmployeeNumber) REFERENCES Employee(EmployeeNumber));


CREATE TABLE Sale (
  SaleNumber INTEGER NOT NULL,
  SaleQuantity SMALLINT NOT NULL DEFAULT 1,
  ItemName VARCHAR(30) NOT NULL,
  DepartmentName VARCHAR(10) NOT NULL,
  PRIMARY KEY (SaleNumber),
  FOREIGN KEY (ItemName) REFERENCES Item(ItemName),
  FOREIGN KEY (DepartmentName) REFERENCES Department(DepartmentName));

CREATE TABLE Supplier (
  SupplierNumber INTEGER NOT NULL,
  SupplierName VARCHAR(30) NOT NULL,
  PRIMARY KEY (SupplierNumber));

CREATE TABLE Delivery (
  DeliveryNumber INTEGER NOT NULL,
  DeliveryQuantity SMALLINT NOT NULL DEFAULT 1,
  ItemName VARCHAR(30) NOT NULL,
  DepartmentName VARCHAR(10) NOT NULL,
  SupplierNumber INTEGER NOT NULL,
  PRIMARY KEY (DeliveryNumber),
  FOREIGN KEY (ItemName) REFERENCES Item(ItemName),
  FOREIGN KEY (DepartmentName) REFERENCES Department(DepartmentName),
  FOREIGN KEY (SupplierNumber) REFERENCES Supplier(SupplierNumber));


-- using the data in the text files, insert into the tables this information
-- What i did was 
-- .mode tab
-- import XXX.txt XXX (.e.g .import item.txt Item

-- Name of employees from marketing departiment 

SELECT EmployeeName FROM Employee WHERE DepartmentName = 'Marketing';

-- Find the items sold by the departments on the second floor.

SELECT ItemName FROM Sale,Department WHERE Sale.DepartmentName = Department.DepartmentName AND Department.DepartmentFloor= 2;

-- test natural join of above . It removes duplicates.

SELECT DISTINCT ItemName
FROM (Sale NATURAL JOIN Department)
WHERE Department.DepartmentFloor = 2;

-- test join of above

SELECT DISTINCT ItemName
FROM (Sale JOIN Department)
WHERE Department.DepartmentFloor = 2;

--  Identify by floor the items available on floors other than the second floor
Select DISTINCT ItemName, DepartmentFloor AS 'Item on floor' FROM Sale, Department WHERE Sale.DepartmentName = Department.DepartmentName AND Department.DepartmentFloor != 2;

-- 4. Find the average salary of the employees in the Clothes department
SELECT AVG(EmployeeSalary) FROM Employee WHERE DepartmentName = 'Clothes';

-- Find, for each department, the average salary of the employees in that department and report by descending salary.

SELECT DepartmentName, AVG(EmployeeSalary)AS Avg_Salary FROM Employee GROUP BY DepartmentName ORDER BY Avg_Salary DESC;

-- List the items delivered by exactly one supplier (i.e. the items always delivered by the same supplier).

SELECT DISTINCT ItemName, SupplierName FROM Delivery, Supplier WHERE Delivery.SupplierNumber = Supplier.SupplierNumber GROUP BY ItemName HAVING COUNT(DISTINCT SupplierName) = 1;

--  List the suppliers that deliver at least 10 items.

SELECT SupplierName, COUNT(DISTINCT ItemName) AS Number_of_Items FROM Delivery, Supplier WHERE Delivery.SupplierNumber = Supplier.SupplierNumber GROUP BY SupplierName HAVING COUNT(DISTINCT ItemName) >= 10;

-- . What is the average delivery quantity of items of type 'N' delivered by each company

SELECT Item.ItemType, Supplier.SupplierName, AVG(DeliveryQuantity) FROM Item, Delivery, Supplier WHERE Item.ItemName = Delivery.ItemName AND Supplier.SupplierNumber=Delivery.SupplierNumber AND ItemType = 'N' GROUP BY SupplierName;

