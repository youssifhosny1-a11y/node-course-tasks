-- Q1: number of books for each author (include authors with none)
SELECT a.id, a.name, COUNT(b.id) AS books_count
FROM authors a
LEFT JOIN books b ON b.author_id = a.id
GROUP BY a.id, a.name
ORDER BY books_count DESC;

-- Q2: authors with more than 3 books
SELECT a.id, a.name, COUNT(b.id) AS books_count
FROM authors a
JOIN books b ON b.author_id = a.id
GROUP BY a.id, a.name
HAVING COUNT(b.id) > 3;

-- Q3: countries that have more than 1 author
SELECT country, COUNT(*) AS authors_count
FROM authors
GROUP BY country
HAVING COUNT(*) > 1;

-- Q4: top 5 customers by total order price
SELECT c.id, c.name, SUM(oi.quantity * oi.cost) AS total_price
FROM customers c
JOIN orders o       ON o.customer_id = c.id
JOIN order_item oi  ON oi.order_id   = o.id
GROUP BY c.id, c.name
ORDER BY total_price DESC
LIMIT 5;

-- Q5: customers that spent more than 100 in total
SELECT c.id, c.name, SUM(oi.quantity * oi.cost) AS total_spent
FROM customers c
JOIN orders o       ON o.customer_id = c.id
JOIN order_item oi  ON oi.order_id   = o.id
GROUP BY c.id, c.name
HAVING SUM(oi.quantity * oi.cost) > 100;

-- Q6: customers with no orders
SELECT c.id, c.name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
WHERE o.id IS NULL;

-- Q7: books that were never ordered
SELECT b.id, b.title
FROM books b
LEFT JOIN order_item oi ON oi.book_id = b.id
WHERE oi.book_id IS NULL;

-- Q8: top 5 books by number sold (not total price) with author name
SELECT b.id, b.title, a.name AS author_name, SUM(oi.quantity) AS total_sold
FROM books b
JOIN authors a     ON a.id = b.author_id
JOIN order_item oi ON oi.book_id = b.id
GROUP BY b.id, b.title, a.name
ORDER BY total_sold DESC
LIMIT 5;

-- Q9: total amount sold per country (country of the book's author)
SELECT a.country, SUM(oi.quantity * oi.cost) AS total_amount
FROM order_item oi
JOIN books b   ON b.id = oi.book_id
JOIN authors a ON a.id = b.author_id
GROUP BY a.country
ORDER BY total_amount DESC;

-- Q10: customers with less than 2 orders (including 0 orders)
SELECT c.id, c.name, COUNT(o.id) AS orders_count
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(o.id) < 2;

-- Q11: orders with 3 or more different books
SELECT oi.order_id, COUNT(DISTINCT oi.book_id) AS different_books
FROM order_item oi
GROUP BY oi.order_id
HAVING COUNT(DISTINCT oi.book_id) >= 3;