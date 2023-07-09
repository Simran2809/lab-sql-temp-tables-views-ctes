-- Challenge
-- Creating a Customer Summary Report

-- In this exercise, you will create a customer summary report that summarizes key information about customers in the 
-- Sakila database, including their rental history and payment details. The report will be generated using a combination 
-- of views, CTEs, and temporary tables.
USE sakila;

-- Step 1: Create a View
-- First, create a view that summarizes rental information for each customer. The view should include the customer's ID, 
-- name, email address, and total number of rentals (rental_count).
CREATE VIEW rental_summary AS
SELECT customer.customer_id, CONCAT(customer.first_name, ' ', customer.last_name) AS customer_name, customer.email, COUNT(*) AS rental_count
FROM rental
JOIN customer ON rental.customer_id = customer.customer_id
GROUP BY customer.customer_id, customer.email;


-- Step 2: Create a Temporary Table
-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and 
-- calculate the total amount paid by each customer.
CREATE TEMPORARY TABLE payment_summary AS
SELECT customer_id, SUM(amount) AS total_paid
FROM payment
GROUP BY customer_id;


-- Step 3: Create a CTE and the Customer Summary Report
-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.

-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived 
-- column from total_paid and rental_count.

WITH customer_summary AS (
    SELECT rental_summary.customer_name, rental_summary.email, rental_summary.rental_count, payment_summary.total_paid
    FROM rental_summary
    JOIN payment_summary ON rental_summary.customer_id = payment_summary.customer_id
)
SELECT customer_name, email, rental_count, total_paid, (total_paid / rental_count) AS average_payment_per_rental
FROM customer_summary;
