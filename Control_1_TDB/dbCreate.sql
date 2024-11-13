-- Creación de la tabla Región
CREATE TABLE IF NOT EXISTS Region (
    region_id INT PRIMARY KEY NOT NULL,
    name char(100) NOT NULL
);

-- Creación de la tabla Communa
CREATE TABLE IF NOT EXISTS Communa (
    communa_id INT PRIMARY KEY NOT NULL,
    name char(50) NOT NULL,
    region_id INT NOT NULL,
    FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

-- Creación de la tabla Address
CREATE TABLE IF NOT EXISTS Address (
    address_id INT PRIMARY KEY NOT NULL,
    communa_id INT NOT NULL,
    address_name char(50) NOT NULL,
    address_number INT NOT NULL,
    FOREIGN KEY (communa_id) REFERENCES Communa(communa_id)
);

-- Creación de la tabla Customer
CREATE TABLE IF NOT EXISTS Customer (
    customer_id INT PRIMARY KEY NOT NULL,
    customer_name char(50) NOT NULL,
    customer_address int NOT NULL,
    FOREIGN KEY (customer_address) REFERENCES Address(address_id)
);

-- Creación de la tabla Company
CREATE TABLE IF NOT EXISTS Company (
    company_id INT PRIMARY KEY NOT NULL,
    company_name char(50) NOT NULL
);

-- Creación de la tabla Product
CREATE TABLE IF NOT EXISTS Product (
    product_id INT PRIMARY KEY NOT NULL,
    company_id INT NOT NULL,
    product_name char(100) NOT NULL,
    FOREIGN KEY (company_id) REFERENCES Company(company_id)
);

-- Creación de la tabla Delivery Man
CREATE TABLE IF NOT EXISTS Delivery_Man (
    delivery_man_id INT PRIMARY KEY NOT NULL,
    delivery_man_name char(50) NOT NULL
);

-- Creación de la tabla Means of Transportation
CREATE TABLE IF NOT EXISTS Means_of_Transportation (
    id INT PRIMARY KEY NOT NULL,
    delivery_man_id INT NOT NULL,
    type_transportation char(50),
    FOREIGN KEY (delivery_man_id) REFERENCES Delivery_Man(delivery_man_id)
);

-- Creación de la tabla Detailed Selling
CREATE TABLE IF NOT EXISTS Detailed_Selling (
    detailed_selling_id INT PRIMARY KEY NOT NULL,
    customer_id INT NOT NULL,
    total_amount_money INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

-- Creación de la tabla Orders
CREATE TABLE IF NOT EXISTS Orders (
    order_id INT PRIMARY KEY NOT NULL,
    customer_id INT NOT NULL,
    delivery_man_id INT NOT NULL,
    detailed_selling_id INT NOT NULL,
    order_date date NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (delivery_man_id) REFERENCES Delivery_Man(delivery_man_id),
    FOREIGN KEY (detailed_selling_id) REFERENCES Detailed_Selling(detailed_selling_id)
);


CREATE TABLE IF NOT EXISTS Detailed_Selling_Product (
	detailed_delling_droduct_id INT PRIMARY KEY NOT NULL,
	detailed_selling_id int NOT NULL,
	product_id int NOT NULL,
	FOREIGN KEY (detailed_selling_id) REFERENCES Detailed_Selling (detailed_selling_id),
	FOREIGN KEY (product_id) REFERENCES Product (Product_id)
);

CREATE TABLE IF NOT EXISTS Delivery_Man_Communa (
	delivery_man_communa_id INT PRIMARY KEY NOT NULL,
	delivery_man_id INT NOT NULL,
	communa_id INT NOT NULL,
	FOREIGN KEY (delivery_man_id) REFERENCES delivery_man(delivery_man_id),
	FOREIGN KEY (communa_id) REFERENCES communa(communa_id)
	
);

CREATE TABLE IF NOT EXISTS Company_Communa (
	company_communa_id INT PRIMARY KEY NOT NULL,
	company_id INT NOT NULL,
	communa_id INT NOT NULL,
	FOREIGN KEY (communa_id) REFERENCES communa(communa_id),
	FOREIGN KEY (company_id) REFERENCES Company(company_id)

);
