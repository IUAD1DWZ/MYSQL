#task1

CREATE DATABASE IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    author_name VARCHAR(255) NOT NULL
);

CREATE TABLE genres (
    genre_id INT AUTO_INCREMENT PRIMARY KEY,
    genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year YEAR NOT NULL,
    author_id INT,
    genre_id INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

CREATE TABLE borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT,
    user_id INT,
    borrow_date DATE NOT NULL,
    return_date DATE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);


#task2

-- Дані
INSERT INTO authors (author_name) VALUES ('Джордж Орвелл'), ('Агата Крісті');
INSERT INTO genres (genre_name) VALUES ('Антиутопія'), ('Детектив');
INSERT INTO books (title, publication_year, author_id, genre_id) VALUES ('1984', 1949, 1, 1), ('Вбивство у Східному експресі', 1934, 2, 2);
INSERT INTO users (username, email) VALUES ('ivan_petrov', 'ivan@example.com'), ('olena_k', 'olena@example.com');
INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date) VALUES (1, 1, '2026-05-01', '2026-05-15');


#task3

#4. Виконайте запити, перелічені нижче.
#Визначте, скільки рядків ви отримали (за допомогою оператора COUNT).
USE mydb;
SELECT COUNT(*) AS total_rows
FROM order_details
INNER JOIN orders ON order_details.order_id = orders.id
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id;


#Змініть декілька операторів INNER на LEFT чи RIGHT. Визначте, що відбувається з кількістю рядків. Чому? 
#Напишіть відповідь у текстовому файлі.

SELECT COUNT(*) AS total_rows
FROM order_details
RIGHT JOIN orders ON order_details.order_id = orders.id
RIGHT JOIN customers ON orders.customer_id = customers.id
RIGHT JOIN employees ON orders.employee_id = employees.employee_id
LEFT JOIN shippers ON orders.shipper_id = shippers.id
LEFT JOIN products ON order_details.product_id = products.id
LEFT JOIN categories ON products.category_id = categories.id
LEFT JOIN suppliers ON products.supplier_id = suppliers.id;

#Висновок: при заміні INNER JOIN на LEFT JOIN кількість рядків зростає, якщо у головній 
#таблиці є записи (ключі), для яких немає відповідних збігів у підпорядкованій таблиці .
#Це допомагає виявити "сирітські" записи та порушення цілісності даних, які зазвичай 
#ігноруються при використанні INNER JOIN.

#На основі запита з пункта 3 виконайте наступне: 
#оберіть тільки ті рядки, де employee_id > 3 та ≤ 10.

SELECT *
FROM order_details
INNER JOIN orders ON order_details.order_id = orders.id
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN employees ON orders.employee_id = employees.employee_id
INNER JOIN shippers ON orders.shipper_id = shippers.id
INNER JOIN products ON order_details.product_id = products.id
INNER JOIN categories ON products.category_id = categories.id
INNER JOIN suppliers ON products.supplier_id = suppliers.id
WHERE orders.employee_id > 3 AND orders.employee_id <= 10;

#Згрупуйте за іменем категорії, порахуйте кількість рядків у групі, 
#середню кількість товару (кількість товару знаходиться в order_details.quantity)

SELECT 
    c.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) AS average_quantity
FROM categories AS c
INNER JOIN products AS p ON c.id = p.category_id
INNER JOIN order_details AS od ON p.id = od.product_id
GROUP BY c.name;

#Відфільтруйте рядки, де середня кількість товару більша за 21.

SELECT 
    c.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) AS average_quantity
FROM categories AS c
INNER JOIN products AS p ON c.id = p.category_id
INNER JOIN order_details AS od ON p.id = od.product_id
GROUP BY c.name
HAVING AVG(od.quantity) > 21;

#Відсортуйте рядки за спаданням кількості рядків.

SELECT 
    c.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) AS average_quantity
FROM categories AS c
INNER JOIN products AS p ON c.id = p.category_id
INNER JOIN order_details AS od ON p.id = od.product_id
GROUP BY c.name
HAVING AVG(od.quantity) > 21
ORDER BY total_rows DESC;

#Виведіть на екран (оберіть) чотири рядки з пропущеним першим рядком.

SELECT 
    c.name AS category_name, 
    COUNT(*) AS total_rows, 
    AVG(od.quantity) AS average_quantity
FROM categories AS c
INNER JOIN products AS p ON c.id = p.category_id
INNER JOIN order_details AS od ON p.id = od.product_id
GROUP BY c.name
HAVING AVG(od.quantity) > 21
ORDER BY total_rows DESC
LIMIT 4 OFFSET 1;