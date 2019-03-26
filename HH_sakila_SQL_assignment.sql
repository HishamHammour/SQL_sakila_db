-- SQL Assignment: 
-- Using sakila Data Base
USE sakila;

-- 1a. Display First and Last Name of all actors:
SELECT first_name, last_name
FROM actor;

-- 1b. Display first and last name of each actor in a single column in upper case letter. Named the column 'Actor Name'in all:
SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS 'Actor Name'
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

SELECT actor_id, first_name, last_name
FROM actor
WHERE actor.first_name LIKE 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor.last_name LIKE '%GEN%';

--2c. Find all actors whose last names contain the letters LI 
-- and order the rows by last name and first name, in that order:
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor.last_name LIKE '%LI%'
ORDER BY last_name , first_name;

-- 2d. Using IN, display the country_id and country columns of the
-- following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country.country IN ('Afghanistan' , 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor.
-- You don't think you will be performing queries on a description,
-- so create a column in the table actor named description and use the data type BLOB
--(Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
 
ALTER TABLE actor
ADD COLUMN description BLOB
AFTER last_name;

-- 3b. delete the description column
ALTER TABLE actor 
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that
-- last name,but only for names that are shared by at least two actors
SELECT last_name, COUNT(last_name) AS Number_of_Actors
FROM actor
GROUP BY last_name
HAVING Number_of_Actors > 1;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
-- Write a query to fix the record.  
UPDATE actor 
SET first_name = 'HARPO'
WHERE actor.first_name = 'GROUCHO'
AND actor.last_name = 'WILLIAMS';

-- 4d. Correcting the first back to GROUCHO 
UPDATE actor 
SET first_name =
					CASE
						WHEN first_name= 'HARPO' THEN 'GROUCHO'
					END
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table.
-- Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address,
-- of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address.address
FROM staff LEFT JOIN address 
ON staff.address_id = address.address_id ;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005
-- Use tables staff and payment.
SELECT 
    staff.first_name,
    staff.last_name,
    SUM(payment.amount) AS Total_amount
FROM payment LEFT JOIN staff
             ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE '2005-08%'
GROUP BY staff.last_name , staff.first_name;

-- 6c. List each film and the number of actors who are listed for that film.
-- Use tables film_actor and film. Use inner join.
SELECT 
    film.title, COUNT(film_actor.actor_id) AS num_of_actors
FROM
    film_actor
        INNER JOIN
    film ON film_actor.film_id = film.film_id
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT 
    COUNT(inventory.film_id)
FROM
    inventory
WHERE
    inventory.film_id = (SELECT 
            film_id
        FROM
            film
        WHERE
            film.title = 'Hunchback Impossible');

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid
-- by each customer. List the customers alphabetically by last name:
SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS Total
FROM payment LEFT JOIN customer 
ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name , customer.last_name
ORDER BY customer.last_name ASC;