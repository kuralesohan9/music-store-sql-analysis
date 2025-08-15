-- ==========================================================
-- Music Store SQL Analysis
-- Author: Sohan Kurale
-- Description: Business insights from Music Store database
-- Database: music_database (MySQL)
-- ==========================================================

-- =========================
-- DATABASE SELECTION
-- =========================
CREATE DATABASE IF NOT EXISTS music_database;
USE music_database;

-- Optional: Preview tables
-- SELECT * FROM employee;
-- SELECT * FROM customer;
-- SELECT * FROM invoice;
-- SELECT * FROM invoice_line;
-- SELECT * FROM album2;
-- SELECT * FROM artist;
-- SELECT * FROM genre;
-- SELECT * FROM media_type;
-- SELECT * FROM playlist;
-- SELECT * FROM track;


-- ==========================================================
-- 1. BASE ANALYSIS
-- ==========================================================

-- Q1: Find the senior-most employee based on job level
SELECT *
FROM employee
ORDER BY levels DESC
LIMIT 1;

-- Q2: Identify the country with the most invoices
SELECT COUNT(*) AS total_invoices, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC
LIMIT 1;

-- Q3: Retrieve the top 3 highest invoice totals
SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

-- Q4: Find the city generating the highest revenue from invoices
SELECT SUM(total) AS total_revenue, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY total_revenue DESC
LIMIT 1;

-- Q5: Identify the customer who spent the most money
SELECT SUM(total) AS total_spent, c.*
FROM customer c
JOIN invoice i ON i.customer_id = c.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;


-- ==========================================================
-- 2. MODERATE ANALYSIS
-- ==========================================================

-- Q1: List all Rock music listeners (email, first name, last name), ordered by email
SELECT DISTINCT c.email, c.first_name, c.last_name
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
WHERE track_id IN (
    SELECT t.track_id
    FROM track t
    JOIN genre g ON g.genre_id = t.genre_id
    WHERE g.name = 'Rock'
)
ORDER BY email;

-- Q2: Top 10 Rock artists by number of tracks
SELECT artist.name, COUNT(track.track_id) AS number_of_songs
FROM track
JOIN album2 ON album2.album_id = track.album_id
JOIN artist ON artist.artist_id = album2.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name = 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC
LIMIT 10;

-- Q3: Tracks longer than the average song length
SELECT name, milliseconds
FROM track
WHERE milliseconds > (
    SELECT AVG(milliseconds) FROM track
)
ORDER BY milliseconds DESC;


-- ==========================================================
-- 3. ADVANCED ANALYSIS
-- ==========================================================

-- Q1: Amount spent by each customer on the best-selling artist
WITH best_selling_artist AS (
    SELECT artist.name AS artist_name,
           artist.artist_id,
           SUM(il.unit_price * il.quantity) AS total_sales
    FROM invoice_line il
    JOIN track t ON t.track_id = il.track_id
    JOIN album2 a ON a.album_id = t.album_id
    JOIN artist ON artist.artist_id = a.artist_id
    GROUP BY artist.artist_id
    ORDER BY total_sales DESC
    LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name,
       bsa.artist_name,
       SUM(il.unit_price * il.quantity) AS total_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album2 a ON a.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = a.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY total_spent DESC;

-- Q2: Most popular music genre per country
WITH genre_per_country AS (
    SELECT c.country,
           g.name AS genre,
           COUNT(*) AS quantity,
           ROW_NUMBER() OVER (PARTITION BY c.country ORDER BY COUNT(*) DESC) AS rn
    FROM customer c
    JOIN invoice i ON i.customer_id = c.customer_id
    JOIN invoice_line il ON il.invoice_id = i.invoice_id
    JOIN track t ON t.track_id = il.track_id
    JOIN genre g ON g.genre_id = t.genre_id
    GROUP BY c.country, g.name
)
SELECT country, genre, quantity
FROM genre_per_country
WHERE rn = 1
ORDER BY country;

-- Q3: Top customer (by spend) per country
WITH customer_with_country AS (
    SELECT c.customer_id, c.first_name, c.last_name,
           i.billing_country,
           SUM(i.total) AS total_spent,
           ROW_NUMBER() OVER (PARTITION BY i.billing_country ORDER BY SUM(i.total) DESC) AS rn
    FROM invoice i
    JOIN customer c ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, i.billing_country
)
SELECT *
FROM customer_with_country
WHERE rn = 1
ORDER BY billing_country;
