USE sakila;
/* Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count). */

SELECT * FROM customer;
SELECT * FROM payment;


CREATE VIEW rental_info AS (
	SELECT c.customer_id, c.first_name, c.last_name, COUNT(r.rental_id) AS total_rent, c.email
	FROM customer AS c
	LEFT JOIN rental AS r
	ON c.customer_id = r.customer_id
	GROUP BY c.customer_id);

-- cheking the practical view usage
    
SELECT customer_id, first_name, last_name, total_rent
FROM rental_info
ORDER BY total_rent DESC
LIMIT 10;


/* Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer. */

CREATE TEMPORARY TABLE payment_information AS
SELECT ri.customer_id, ri.first_name, ri.last_name, SUM(p.amount) AS total_pay
FROM rental_info AS ri
LEFT JOIN payment AS p
ON ri.customer_id = p.customer_id
GROUP BY ri.customer_id;

-- checking the table
SELECT * FROM payment_information;

/* Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.
Next, using the CTE, create the query to generate the final customer summary report, which should include:
customer name, email, rental_count, total_paid and average_payment_per_rental, 
this last column is a derived column from total_paid and rental_count. */

WITH cte_summary AS (
SELECT ri.customer_id, ri.first_name, ri.last_name, ri.email, pi.total_pay, ri.total_rent
FROM payment_information AS pi
JOIN rental_info AS ri
ON pi.customer_id = ri.customer_id)

SELECT customer_id, first_name, last_name, email, total_rent, total_pay, ROUND(total_pay/total_rent, 2) AS average_payment_per_rental
FROM cte_summary;


