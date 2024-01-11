-- INSERINDO DADOS FICTÍCIOS

USE e_storex;
-- Inserindo clientes
INSERT INTO clients(fname, lname, cpf, location, contact) VALUES
('Alice', 'Smith', '12345678901', 'City A', '123-456-7890'),
('Bob', 'Johnson', '98765432101', 'City B', '987-654-3210'),
('Charlie', 'Brown', '11122233344', 'City C', '111-222-3333'),
('David', 'Wilson', '44455566677', 'City D', '444-555-6666'),
('Emma', 'Davis', '88899900011', 'City E', '888-999-0000'),
('Frank', 'Anderson', '55544433322', 'City F', '555-444-3333'),
('Grace', 'Thomas', '99988877766', 'City G', '999-888-7777'),
('Henry', 'Miller', '33322211100', 'City H', '333-222-1111'),
('Ivy', 'Garcia', '77766655544', 'City I', '777-666-5555'),
('Jack', 'Perez', '22211100099', 'City J', '222-111-0000');

-- Inserindo produtos
INSERT INTO product(p_name, p_description, price, category) VALUES
('Chair', 'Comfortable chair for home use', 50.99, 'furniture'),
('Pizza', 'Delicious Margherita pizza', 12.99, 'food'),
('T-shirt', 'Cotton casual T-shirt', 19.99, 'clothing'),
('Vase', 'Decorative ceramic vase', 30.99, 'decoration'),
('Table', 'Wooden dining table', 120.99, 'furniture'),
('Laptop', 'High-performance laptop', 899.99, 'electronics'),
('Camera', 'Digital camera with advanced features', 499.99, 'electronics'),
('Bookshelf', 'Sturdy bookshelf for organizing books', 79.99, 'furniture'),
('Jeans', 'Classic denim jeans', 29.99, 'clothing'),
('Gourmet Chocolate', 'Luxurious assorted chocolate box', 25.99, 'food'),
('Desk Lamp', 'Adjustable desk lamp for studying', 35.99, 'decoration'),
('Running Shoes', 'Comfortable running shoes', 69.99, 'clothing'),
('Coffee Table', 'Modern coffee table for the living room', 89.99, 'furniture'),
('Smartphone', 'Latest model smartphone with advanced features', 699.99, 'electronics'),
('Wall Art', 'Abstract wall art for home decor', 49.99, 'decoration');

-- Inserindo vendas
INSERT INTO sells(productid, clientid, date_sold, quantity, total_price) VALUES
(1, 1, '2023-01-01', 2, 101.98),
(2, 3, '2023-02-15', 1, 12.99),
(3, 2, '2023-03-10', 3, 59.97),
(4, 4, '2023-04-05', 1, 30.99),
(5, 5, '2023-05-20', 1, 120.99),
(6, 6, '2023-06-25', 2, 1799.98),
(7, 7, '2023-07-10', 1, 499.99),
(8, 8, '2023-08-18', 2, 159.98),
(9, 9, '2023-09-05', 1, 29.99),
(10, 10, '2023-10-12', 3, 77.97),
(11, 1, '2023-11-20', 1, 35.99),
(12, 3, '2023-12-01', 2, 139.98);

-- Inserindo estoques
INSERT INTO storages(productid, location, quantity) VALUES
(1, 'Warehouse A', 10),
(2, 'Warehouse B', 20),
(3, 'Warehouse C', 15),
(4, 'Warehouse D', 5),
(5, 'Warehouse E', 8);

-- Inserindo revisões
INSERT INTO revision(client_revision, date_creation, rate, comentary) VALUES
(1, '2023-01-15', 9, 'Great customer service!'),
(2, '2023-02-28', 10, 'Excellent products and delivery'),
(3, '2023-03-20', 5, 'Satisfied with the purchase'),
(4, '2023-04-10', 2, 'Product quality could be better'),
(5, '2023-05-25', 7, 'Very happy with the furniture'),
(6, '2023-06-05', 7, 'Fast shipping and good packaging'),
(7, '2023-07-15', 10, 'The camera exceeded my expectations'),
(8, '2023-08-01', 3, 'Average product, expected more'),
(9, '2023-09-10', 9, 'Love the jeans, perfect fit'),
(10, '2023-10-22', 10, 'Beautiful wall art, adds charm to my room');


-- REALIZANDO QUERIES




-- CLIENTES QUE MAIS FIZERAM REVISÕES
SELECT concat(c.fname, ' ',c.lname) AS client_name, cpf, count(client_revision) AS quantity
	FROM clients c 
    LEFT JOIN revision r ON c.idclients = r.client_revision
	GROUP BY client_name, cpf
	ORDER BY quantity DESC;



-- NOTAS BAIXAS E ALTAS
SELECT
	CASE WHEN r.rate > 5 THEN 'high rate'
		WHEN r.rate <= 5 THEN 'low rate'
		END AS rates,
		COUNT(*) AS quantity
	FROM revision r
	GROUP BY rates;



-- QUANTIDADE DE PRODUTOS VENDIDOS
SELECT p.p_name, sum(s.quantity) AS total_quantity_sold
	FROM sells s
    INNER JOIN product p ON p.idproduct = s.productid
	GROUP BY idproduct
    ORDER BY total_quantity_sold DESC;



-- QUANTO CADA CLIENTE GASTOU NO TOTAL
SELECT concat(fname, ' ',lname) AS client_name, count(clientid) AS buy_quantity, round(sum(total_price), 2) AS total_expend
	FROM clients c
    INNER JOIN sells s ON c.idclients = s.clientid
    GROUP BY client_name
    ORDER BY total_expend DESC;



-- COMBINANDO QUERIES PARA RETIRAR BONS INSIGHTS

-- REALIZADA PARA CADA CLIENTE E DEPOIS SE A NOTA DESSA REVISÃO FOI HIGH OU LOW
SELECT concat(c.fname, ' ',c.lname) AS client_name, count(client_revision) AS revision_quantity, r.comentary AS revision_comentary,
		CASE WHEN r.rate > 5 THEN 'high rate'
		WHEN r.rate <= 5 THEN 'low rate'
		END AS rates
	FROM clients c 
    LEFT JOIN revision r ON c.idclients = r.client_revision
    GROUP BY client_name, revision_comentary, rates
	ORDER BY client_name;



-- QUANTIDADE VENDIDA E A QUANTIDADE DE ESTOQUE QUE O PRODUTO POSSUI
SELECT p.p_name, sum(s.quantity) AS total_sold, storages.quantity AS total_storage
	FROM sells s
    INNER JOIN product p ON p.idproduct = s.productid
    INNER JOIN storages ON storages.productid = p.idproduct
	GROUP BY idproduct, total_storage
    ORDER BY total_sold DESC;



-- PRODUTO, QUANTIDADE DE ESTOQUE E QUANTO O ESTOQUE VALE
SELECT p.p_name AS product_name, s.quantity AS storage_quantity, 
       CASE 
           WHEN s.quantity >= 1 THEN round((s.quantity * p.price), 2)
           ELSE p.price
       END AS quantity_worth
	FROM product p
	LEFT JOIN storages s ON p.idproduct = s.productid
	ORDER BY quantity_worth DESC;

-- NOTA DE CADA CLIENTE
SELECT concat(c.fname, ' ',c.lname) AS client_name, r.rate
	FROM revision r
    INNER JOIN clients c ON r.client_revision = c.idclients














