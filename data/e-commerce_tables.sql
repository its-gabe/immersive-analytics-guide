-- CRIAÇÃO DAS TABELAS

-- SHOW DATABASES;
CREATE DATABASE IF NOT EXISTS E_StoreX;
USE e_storex;

-- DROP DATABASE e_storex;

CREATE TABLE clients(
	idclients INT PRIMARY KEY AUTO_INCREMENT,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20),
    cpf CHAR(11) NOT NULL,
    location VARCHAR(45),
    contact CHAR(15) NOT NULL
);

CREATE TABLE product(
	idproduct INT PRIMARY KEY AUTO_INCREMENT,
    p_name VARCHAR(45) NOT NULL,
    p_description VARCHAR(100),
    price FLOAT NOT NULL,
    category ENUM('furniture','food','clothing','decoration','electronics') NOT NULL
);

CREATE TABLE sells(
	idsells INT AUTO_INCREMENT,
    productid INT,
    clientid INT,
    date_sold DATE NOT NULL,
    quantity INT NOT NULL,
    total_price FLOAT NOT NULL,
    PRIMARY KEY (idsells, productid, clientid),
    CONSTRAINT fk_product_sold_info FOREIGN KEY (productid) REFERENCES product(idproduct),
    CONSTRAINT fk_client_buy_info FOREIGN KEY (clientid) REFERENCES clients(idclients)
);

CREATE TABLE storages(
	idstorages INT AUTO_INCREMENT,
    productid INT,
    location VARCHAR(45) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    PRIMARY KEY (idstorages, productid),
    CONSTRAINT fk_info_product FOREIGN KEY (productid) REFERENCES product(idproduct)
);

CREATE TABLE revision(
	idrevision INT AUTO_INCREMENT,
    client_revision INT,
    date_creation DATE NOT NULL,
    rate INT DEFAULT 0,
    comentary VARCHAR(200),
    PRIMARY KEY (idrevision, client_revision),
    CONSTRAINT fk_client_revision FOREIGN KEY (client_revision) REFERENCES clients(idclients)
);

SHOW TABLES;