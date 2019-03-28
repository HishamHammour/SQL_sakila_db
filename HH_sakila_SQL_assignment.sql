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
SELECT film.title, COUNT(film_actor.actor_id) AS num_of_actors
FROM film_actor
INNER JOIN film
ON film_actor.film_id = film.film_id
GROUP BY film.title;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(inventory.film_id)
FROM inventory
WHERE inventory.film_id =
    (SELECT film_id
    FROM film
    WHERE film.title = 'Hunchback Impossible');

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid
-- by each customer. List the customers alphabetically by last name:
SELECT 
    customer.first_name,
    customer.last_name,
    SUM(payment.amount) AS Total
FROM payment
LEFT JOIN customer 
ON customer.customer_id = payment.customer_id
GROUP BY customer.first_name , customer.last_name
ORDER BY customer.last_name ASC;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely
-- resurgence. As an unintended consequence, films starting
-- with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting
-- with the letters K and Q whose language is English.
SELECT film.title
FROM film
WHERE film.language_id =
    (SELECT language_id
    FROM language
    WHERE language.name = 'English')
AND film.title LIKE 'K%'
OR film.title LIKE 'Q%';

-- 7b. Use subqueries to display all actors who appear in the 
-- film Alone Trip.
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id = 
ANY (SELECT actor_id
	FROM film_actor
	WHERE film_actor.film_id =
		(SELECT film_id
		FROM film
		WHERE film.title = 'Alone Trip'));

-- 7c. You want to run an email marketing campaign in Canada,
-- for which you will need the names and email addresses of all Canadian customers.
-- Use joins to retrieve this information.
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address
ON address.address_id = customer.address_id
INNER JOIN city
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families,
-- and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT title
FROM film
WHERE film.film_id =
ANY (SELECT film_id
	FROM film_category
	WHERE film_category.category_id =
        (SELECT category_id
		FROM category
		WHERE
        name = 'Family'));

-- 7e. Display the most frequently rented movies in descending order.
SELECT title, COUNT(rental.inventory_id) AS Times_Rented
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY Times_Rented DESC;

-- 7f. Write a query to display how much business, in dollars,
-- each store brought in.
SELECT store.store_id, SUM(payment.amount) AS Revenue
FROM store
INNER JOIN staff
ON store.store_id = staff.store_id
INNER JOIN payment
ON payment.staff_id = staff.staff_id
GROUP BY store.store_id
ORDER BY Revenue DESC;

-- 7g. Write a query to display for each store its store ID, city,
-- and country.
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address
ON store.address_id = address.address_id
INNER JOIN city 
ON address.city_id = city.city_id
INNER JOIN country
ON city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order.
-- (Hint: you may need to use the following tables:
-- category, film_category, inventory, payment, and rental.)

SELECT category.name AS Genre, SUM(payment.amount) AS Revenue
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON film_category.film_id = inventory.film_id
INNER JOIN rental
ON inventory.inventory_id = rental.inventory_id
INNER JOIN payment
ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY Revenue DESC
LIMIT 5;


--- 8a. In your new role as an executive, you would like to have an easy
-- way of viewing the Top five genres by gross revenue. Use the solution from
-- the problem above to create a view.

CREATE VIEW top_5_genres_by_revenue AS 
    SELECT category.name AS Genre, SUM(payment.amount) AS Revenue
    FROM category
    INNER JOIN film_category
    ON category.category_id = film_category.category_id
    INNER JOIN inventory
    ON film_category.film_id = inventory.film_id
    INNER JOIN rental
    ON inventory.inventory_id = rental.inventory_id
    INNER JOIN payment
    ON rental.rental_id = payment.rental_id
    GROUP BY category.name
    ORDER BY Revenue DESC
    LIMIT 5;

-- 8b. How would you display the view that you created in 8a?

SELECT * FROM top_5_genres_by_revenue;

-- 8c. You find that you no longer need the view top_five_genres.
-- Write a query to delete it.
DROP VIEW top_5_genres_by_revenue;