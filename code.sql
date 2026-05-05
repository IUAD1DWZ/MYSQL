#task1
SELECT * 
FROM mydb.products;
SELECT name, phone
FROM mydb.shippers;

#task2

SELECT 
    AVG(price) AS average_price,
    MAX(price) AS max_price,
    MIN(price) AS min_price
FROM mydb.products;

#task3

SELECT DISTINCT category_id, price
FROM mydb.products
ORDER BY price DESC
LIMIT 10;

#task4

SELECT COUNT(*) AS products_count
FROM mydb.products
WHERE price BETWEEN 20 AND 100;

#task5

SELECT 
    supplier_id, 
    COUNT(*) AS total_products, 
    AVG(price) AS average_price
FROM mydb.products
GROUP BY supplier_id;