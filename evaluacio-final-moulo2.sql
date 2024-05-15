-- Evaluacion final modulo 2 Lidia

USE sakila;


-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados
SELECT DISTINCT title --  elimina los registros duplicados de los resultados 
FROM film 


-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"
SELECT title,rating
FROM film
WHERE rating= "PG-13";


-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
SELECT title, description
FROM film
WHERE description LIKE "%amazing%";  -- LIKE para buscar un patron especifico, que coincidan parcialmente. ..%palabra%...


-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos
SELECT title,length
FROM film
WHERE length > 120;


-- 5. Recupera los nombres de todos los actores
SELECT first_name,last_name
FROM actor;


-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%Gibson%";


-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.
SELECT actor_id, first_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;


-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación
SELECT title, rating
FROM film 
WHERE rating NOT IN ("R", "PG-13");


/* 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la 
clasificación junto con el recuento */
SELECT rating, COUNT(film_id) AS cantidad_total_peliculas
FROM film
GROUP BY rating;


/* 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su 
nombre y apellido junto con la cantidad de películas alquiladas*/
SELECT customer.customer_id, first_name, last_name, COUNT(film_id) AS peliculas_alquiladas
FROM rental 
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
-- join con clientes para acceder a sus nombres y apellidos
LEFT JOIN customer
ON  rental.customer_id = customer.customer_id
GROUP BY customer_id;


/* 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la 
categoría junto con el recuento de alquileres. */
SELECT film_category.category_id, name, COUNT(inventory.film_id) AS peliculas_alquiladas
FROM rental 
LEFT JOIN inventory
ON rental.inventory_id = inventory.inventory_id
LEFT JOIN film_category
ON inventory.film_id = film_category.film_id
LEFT JOIN category
ON  film_category.category_id = category.category_id
GROUP BY film_category.category_id;



/*12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y 
muestra la clasificación junto con el promedio de duración*/
SELECT rating AS clasificacion, ROUND(AVG(length),2) AS promedio_duracion
--  La segunda columna es el resultado de la función AVG(length), que calcula el promedio de la duración de las películas en minutos, este promedio se redondea a dos decimales
FROM film 
GROUP BY rating; -- divide los datos en grupos basados en los valores de la columna especificad (AVG, SUM; etc )


-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
SELECT actor.first_name, actor.last_name, film.title   
FROM film_actor 
INNER JOIN film
ON film_actor.film_id = film.film_id
INNER JOIN actor
ON film_actor.actor_id = actor.actor_id
WHERE title = 'Indian Love'; 



-- 14 Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.
SELECT title, description
FROM film                           -- probar en todas las posiciones las palabras dog and cat.
WHERE description LIKE '% dog %' 
	OR description LIKE '% cat %' 
	OR description LIKE 'cat %'
	OR description LIKE 'dog %'
	OR description LIKE '% dog'
	OR description LIKE '% cat';


-- 15 Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor.
SELECT actor_id 
FROM actor 
WHERE actor_id NOT IN (SELECT actor_id FROM film_actor); -- solo se seleccionan los actor_id que no están asociados con ninguna película en la tabla film_actor.
-- no hay ningún actor que no aparezca en alguna de las películas de la tabla film_actor (estan todos los id en las dos tablas(1-200))


-- 16 Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.
SELECT title, release_year
FROM film 
WHERE release_year BETWEEN 2005 AND 2010;



-- 17 Encuentra el título de todas las películas que son de la misma categoría que "Family".
SELECT film.title, category.name
FROM film 
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category
ON film_category.category_id = category.category_id
WHERE name = 'Family';


-- 18 Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.
SELECT actor.first_name, actor.last_name, COUNT(film_id) AS numero_peliculas
FROM film_actor   
LEFT JOIN actor
ON film_actor.actor_id = actor.actor_id
GROUP BY film_actor.actor_id
HAVING numero_peliculas > 10;


-- 19 Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.
SELECT title, rating, length
FROM film
WHERE rating = 'R' 
AND length > 120;    -- 2 horas=120minutos, columna duracion


/* 20 Encuentra las categorías de películas que tienen un promedio de duración superior a 120 
minutos y muestra el nombre de la categoría junto con el promedio de duración */
SELECT film_category.category_id, name, AVG(length) AS promedio_duracion
FROM film 
LEFT JOIN film_category
ON film_category.film_id = film.film_id
LEFT JOIN category
ON film_category.category_id = category.category_id
GROUP BY category_id
HAVING promedio_duracion > 120;


/* 21 Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor 
junto con la cantidad de películas en las que han actuado*/
SELECT actor.first_name, COUNT(film_id) AS numero_peliculas  -- que queremos traer
FROM film_actor                      -- tabla principal
LEFT JOIN actor           -- Une la tabla film_actor con la tabla actor. LEFT JOIN asegura que se conserven todas las filas de la tabla de la izquierda"film_actor".
ON film_actor.actor_id = actor.actor_id    -- la condicion
GROUP BY actor.actor_id           --  agrupa los resultados en actor.actor_id (unico)  
HAVING numero_peliculas >= 5;     -- filtra los resultados después de que se hayan agrupado utilizando una condición específica



/* 22 Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una 
subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona 
las películas correspondientes */
SELECT title
FROM film
WHERE film_id IN 
    (SELECT film_id
    FROM inventory
    WHERE inventory_id IN 
       (SELECT inventory_id
        FROM rental
        WHERE DATEDIFF(return_date, rental_date) > 5));







/*23 Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la 
categoría "Horror". Utiliza una subconsulta para encontrar los actores que han actuado en 
películas de la categoría "Horror" y luego exclúyelos de la lista de actores */
-- actores no en la lista de actores, en pelis de horror
SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN   -- id actores en las pelis de categoria 'Horror'
	(SELECT actor_id
	 FROM film_actor   
	 WHERE film_id IN   -- id pelis de categoria horror 
          (SELECT film_id
		   FROM film_category
		   WHERE category_id =  -- id de la categoria 'Horror'
				(SELECT category_id
				 FROM category
				 WHERE name = 'Horror'))); 


