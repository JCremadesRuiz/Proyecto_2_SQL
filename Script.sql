/* 2 - Muestra los nombres de todas las películas con una clasificación por 
edades de ‘Rʼ*/

select "title", "rating"
from "film"
where "rating" = 'R';

/* 3 -  Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 
y 40. */

select "actor_id", concat ("first_name",' ',"last_name") as "full_name"
from "actor"
where "actor_id" between 30 and 40;

/* 4 - Obtén las películas cuyo idioma coincide con el idioma original. */

select COUNT(*) 
from "film" 
WHERE "original_language_id" IS NULL;

select "language_id", "original_language_id"
from "film"
where "original_language_id" IS NOT NULL AND "language_id" = "original_language_id";

/* 5 - Ordena las películas por duración de forma ascendente. */

select "title","length"
from "film"
order by length ASC;

/* 6 - Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su 
apellido */

select concat ("first_name",' ', "last_name") as "full_name_ALLEN"
from "actor"
where "last_name" = 'ALLEN';


/* 7 - Encuentra la cantidad total de películas en cada clasificación de la tabla 
“filmˮ y muestra la clasificación junto con el recuento */

select distinct("rating"),count (*) as "total_peliculas"
from "film"
where "rating" is not null
group by "rating";

/*  8 - Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una 
duración mayor a 3 horas en la tabla film. */

select "title","rating", "length"
from "film"
where "rating" = 'PG-13' or "length" > 180; 

/*  9 - Encuentra la variabilidad de lo que costaría reemplazar las películas */

select variance("replacement_cost")
from "film";

/*  10 - Encuentra la mayor y menor duración de una película de nuestra BBDD. */

select max("length") as "duración_maxima", min ("length") as "duración_mínima"
from "film";

/*  11 - Encuentra lo que costó el antepenúltimo alquiler ordenado por día. */

select "amount" as "precio_pagado", "payment_date" as "antepenultima_fecha_de_pago"
from "payment"
order by "payment_date" desc
limit 1 offset 2;


/*  12 - Encuentra el título de las películas en la tabla “filmˮ 
 *  que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación. */

select "title" ,"rating"
from "film"
where "rating" not in ('NC-17','G')

/* 13 - Encuentra el promedio de duración de las películas para cada 
clasificación de la tabla film y muestra la clasificación junto con el 
promedio de duración */

select Round(AVG("length"), 2) as "duración_media", "rating" as "clasificación"
from "film"
group by "rating";

/*  14 - Encuentra el título de todas las películas que tengan una duración mayor 
a 180 minutos */

select "title" as "nombre_pelicula", "length" as "duración_superior_180_minutos"
from "film"
where "length" > 180;

/*  15 - ¿Cuánto dinero ha generado en total la empresa? */

select sum("amount") as "dinero_total_generado"
from "payment";

/* 16 - Muestra los 10 clientes con mayor valor de id.*/

select 
	concat("first_name", ' ', "last_name") as "full_name",
	"customer_id" as "Mayor_valor_ID"
from "customer"
order by "customer_id" desc
limit 10;

/*  17 - Encuentra el nombre y apellido de los actores que aparecen en la 
película con título ‘Egg Igbyʼ */

select actor.first_name,actor.last_name,film.title
from "actor"
inner join "film_actor"
	on actor.actor_id = film_actor.actor_id
inner join "film"
	on film.film_id = film_actor.film_id
where title = 'EGG IGBY';

/* 18 - Selecciona todos los nombres de las películas únicos. */

select distinct("title")
from "film";

/* 19 - Encuentra el título de las películas que son comedias y tienen una 
duración mayor a 180 minutos en la tabla “filmˮ.*/

select film.title,film.length,category.name
from "film"
inner join "film_category"
	on film.film_id = film_category.film_id
inner join "category"
	on category.category_id = film_category.category_id
where name = 'Comedy' and length >= 180;

/* 20 -  Encuentra las categorías de películas que tienen un promedio de 
duración superior a 110 minutos y muestra el nombre de la categoría 
junto con el promedio de duración.*/

select category.name as "Genero",Round(AVG(film.length),2) as "Tiempo_promedio"
from "category"
inner join "film_category"
	on category.category_id = film_category.category_id
inner join "film"
	on film_category.film_id = film.film_id
group by category.name
having AVG(film.length) > 110;

/* 21 -  ¿Cuál es la media de duración del alquiler de las películas? */

select AVG("return_date" - "rental_date") as "duracion_media_alquiler"
from "rental";

/* 22 - Crea una columna con el nombre y apellidos de todos los actores y 
actrices.*/

select Concat ("first_name",' ',"last_name") as "nombre_completo"
from "actor";

/* 23 - Números de alquiler por día, ordenados por cantidad de alquiler de 
forma descendente. */

select DATE("rental_date") as "Fecha", count(*) as "alquiler_dia"
from "rental"
group by date("rental_date")
order by "alquiler_dia" desc;

/* 24 - Encuentra las películas con una duración superior al promedio. */

with duración_superior_promedio AS(
	select avg("length") as "promedio"
	from "film" 
)
select "length", "title"
from "film"
where "length" > (select "promedio" from duración_superior_promedio)

order by "length" asc;

/* 25 - Averigua el número de alquileres registrados por mes.*/

select date_trunc('month',"rental_date") as "mes", count(*) as "Numero_alquileres"
from "rental"
group by date_trunc('month',"rental_date");

/* 26 -  Encuentra el promedio, la desviación estándar y varianza del total 
pagado.*/


select Round(AVG("amount"),2) as "promedio",
Round(stddev("amount"),2) as "desviación_tipica", 
Round(variance("amount"),2) as "varianza"
from "payment";

/* 27 - ¿Qué películas se alquilan por encima del precio medio? */

with superior_precio_medio as (
	select AVG("amount") as promedio
	from "payment"
)

select film.title as "Película",payment.amount
from "film"
inner join "inventory"
	on film.film_id = inventory.film_id
inner join "rental"
	on inventory.inventory_id = rental.inventory_id
inner join "payment"
	on rental.rental_id  = payment.rental_id
where "amount" > (select "promedio" from superior_precio_medio);

/* 28 - Muestra el id de los actores que hayan participado en más de 40 
películas. */

select "actor_id" ,count(*) as "numero_total"
from film_actor
group by "actor_id"
having count (*) > 40;

/* 29 - Obtener todas las películas y, si están disponibles en el inventario, 
mostrar la cantidad disponible. */
 

select film.title,count(inventory.inventory_id)
from "film"
left join "inventory"
	on film.film_id = inventory.film_id
group by "title";

/* 30 - Obtener los actores y el número de películas en las que ha actuado. */

select actor.actor_id, concat (actor.first_name,' ', actor.last_name) as "Actor",count(film_actor.film_id) as "Total_películas"
from "actor"
inner join "film_actor"
	on actor.actor_id = film_actor.actor_id
group by actor.actor_id,"first_name","last_name" 
order by actor.actor_id asc;

/* 31 - Obtener todas las películas y mostrar los actores que han actuado en 
ellas, incluso si algunas películas no tienen actores asociados. */

select film.title,actor.first_name,actor.last_name
from "film"
full join "film_actor"
	on film.film_id = film_actor.film_id
full join "actor"
	on film_actor.actor_id = actor.actor_id;
	
/* 32 - Obtener todos los actores y mostrar las películas en las que han 
actuado, incluso si algunos actores no han actuado en ninguna película. */
	
select actor.first_name,actor.last_name,film.title
from "actor"
full join "film_actor"
	on actor.actor_id = film_actor.actor_id  
full join "film"
	on film_actor.film_id = film.film_id;

/* 33 - Obtener todas las películas que tenemos y todos los registros de 
alquiler. */

select film.title, rental
from "film"
left join "inventory"
	on film.film_id = inventory.film_id
left join "rental"
	on inventory.inventory_id = rental.inventory_id;

/* 34 -  Encuentra los 5 clientes que más dinero se hayan gastado con nosotros. */

select "customer_id", sum("amount") as "total_gastado"
from "payment"
group by "customer_id"
order by "total_gastado" desc
limit 5;

/* 35 - Selecciona todos los actores cuyo primer nombre es 'Johnny'*/

select "first_name","last_name"
from actor a 
where "first_name" = 'JOHNNY';

/* 36 - Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como 
Apellido. */

select "first_name" as "Nombre","last_name" as "Apellido"
from actor a;

/* 37 -  Encuentra el ID del actor más bajo y más alto en la tabla actor.*/

select MIN("actor_id") as "Actor_mas_bajo", max("actor_id") as "Actor_mas_alto" 
from "actor";

/* 38 - Cuenta cuántos actores hay en la tabla “actorˮ */

select COUNT("actor_id")
from "actor";

 /* 39 - Selecciona todos los actores y ordénalos por apellido en orden 
ascendente. */

select "last_name","first_name"
from "actor" 
order by "last_name" asc;

/* 40 - Selecciona las primeras 5 películas de la tabla “filmˮ.*/

select "film_id","title"
from "film"
limit 5;

/* 41 - Agrupa los actores por su nombre y cuenta cuántos actores tienen el 
mismo nombre. ¿Cuál es el nombre más repetido? */

select "first_name", count("first_name") as "cantidad"
from "actor"
group by "first_name"
order by "cantidad" desc;

/* 42 -  Encuentra todos los alquileres y los nombres de los clientes que los 
realizaron. */


select rental.rental_id, customer.first_name
from "rental"
inner join "customer"
 on rental.customer_id = customer.customer_id;

/* 43 - Muestra todos los clientes y sus alquileres si existen, incluyendo 
aquellos que no tienen alquileres. */

select rental.rental_id, customer.first_name
from "rental"
right join "customer"
 on rental.customer_id = customer.customer_id;

/* 44 - Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor 
esta consulta? ¿Por qué? Deja después de la consulta la contestación 
No aporta valor alguno, porque no refleja las relaciones reales entre las peliculas y categorias.*/

select film.* , category.*
from "film"
cross join "category";

/* 45 - Encuentra los actores que han participado en películas de la categoría 
'Action'. */

select actor.first_name , actor.last_name , category.name
from "actor"
inner join "film_actor"
	on actor.actor_id = film_actor.actor_id
inner join "film"
	on film_actor.film_id = film.film_id
inner join "film_category"
	on film.film_id = film_category.film_id
inner join "category"
	on film_category.category_id = category.category_id
where category.name = 'Action';

/* 46 - Encuentra todos los actores que no han participado en películas.
 * No hay actores, al menos todos han participado en una pelicula.*/

select actor.first_name, actor.last_name, film.film_id
from "actor"
left join "film_actor"
	on actor.actor_id = film_actor.actor_id
left join "film"
	on film_actor.film_id = film.film_id
where film.film_id is null;

/*  47 - Selecciona el nombre de los actores y la cantidad de películas en las 
que han participado.*/

select actor.first_name, actor.last_name, count(film.film_id) as "total_peliculas"
from "actor"
left join "film_actor"
	on actor.actor_id = film_actor.actor_id
left join "film"
	on film_actor.film_id = film.film_id
group by actor.first_name, actor.last_name; 

/* 48 - Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres 
de los actores y el número de películas en las que han participado.*/

create view actor_num_peliculas as 

select actor.first_name, actor.last_name, count(film.film_id) as "total_peliculas"
from "actor"
inner join "film_actor"
	on actor.actor_id = film_actor.actor_id
inner join "film"
	on film_actor.film_id = film.film_id
group by actor.actor_id;

select * from actor_num_peliculas a ;

/* 49 - Calcula el número total de alquileres realizados por cada cliente. */
select concat(customer.first_name,' ', customer.last_name) as "Nombre_cliente", 
	COUNT(rental.rental_id ) as "total_alquileres"
from "rental"
inner join "customer"
	on rental.customer_id = customer.customer_id
group by "Nombre_cliente";

/* 50 - Calcula la duración total de las películas en la categoría 'Action'.*/

select SUM(film.length) as "Duracion_total_peliculas_accion"
from "film"
inner join "film_category"
	on film.film_id = film_category.film_id
inner join "category"
	on film_category.category_id = category.category_id
where category.name = 'Action'

/* 51 - Crea una tabla temporal llamada “cliente_rentas_temporalˮ para 
almacenar el total de alquileres por cliente.*/

create temporary table clientes_rentas_temporal as
select concat(customer.first_name,' ', customer.last_name) as "Nombre_cliente", 
COUNT(customer.customer_id) as "total_alquileres"
from "rental"
inner join "customer"
	on rental.customer_id = customer.customer_id
group by "Nombre_cliente";

/* 52 - Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las 
películas que han sido alquiladas al menos 10 veces */

select f.title, COUNT(r.inventory_id)
from rental r 
inner join inventory i 
	on r.inventory_id = i.inventory_id 
inner join film f 
	on i.film_id = f.film_id 
group by f.title
having count (r.inventory_id) >= 10;

/*  53 - Encuentra el título de las películas que han sido alquiladas por el cliente 
con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena 
los resultados alfabéticamente por título de película. */

select concat(c.first_name,' ',c.last_name) as "Nombre_completo",
f.title as "Pelicula_no_devuelta",
r.return_date
from customer c 
inner join rental r 
	on c.customer_id = r.customer_id
inner join inventory i 
	on r.inventory_id = i.inventory_id 
inner join film f 
	on i.film_id = f.film_id 
where c.first_name = 'TAMMY' and c.last_name = 'SANDERS' and r.return_date is null
order by "Pelicula_no_devuelta" asc;

/* 54 -  Encuentra los nombres de los actores que han actuado en al menos una 
película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados 
alfabéticamente por apellido.*/

select a.first_name, a.last_name , c.name,count(f.film_id)
from actor a 
inner join film_actor f 
	on a.actor_id = f.actor_id
inner join film_category f2 
	on f.film_id = f2.film_id
inner join category c 
	on f2.category_id = c.category_id
group by a.first_name, a.last_name, c.name
having c.name = 'Sci-Fi' and count(f.film_id) > 0
order by a.last_name asc;

/* 55 - Encuentra el nombre y apellido de los actores que han actuado en 
películas que se alquilaron después de que la película ‘Spartacus 
Cheaperʼ se alquilara por primera vez. Ordena los resultados 
alfabéticamente por apellido.*/

with despues_spartacus as(
	select min("rental_date") as primera_fecha
	from rental r 
	inner join inventory i 
		on r.inventory_id = i.inventory_id 
	inner join film f 
		on i.film_id = f.film_id 
	where f.title = 'SPARTACUS CHEAPER'
)

select distinct a.first_name, a.last_name
from actor a 
inner join film_actor f 
	on a.actor_id = f.actor_id
inner join film f2 
	on f.film_id = f2.film_id
inner join inventory i 
	on f2.film_id = i.film_id
inner join rental r 
	on i.inventory_id = r.inventory_id
where r.rental_date > (select "primera_fecha" from "despues_spartacus")
order by a.last_name asc;

/* 56 - Encuentra el nombre y apellido de los actores que no han actuado en 
ninguna película de la categoría ‘Musicʼ.*/


select a.first_name,a.last_name
from actor a 
where not exists(
select 1
from film_actor fa
inner join film_category fc
	on fa.film_id = fc.film_id
inner join category c
	on fc.category_id = c.category_id
where a.actor_id = fa.actor_id and c.name = 'Music' )
order by a.last_name asc;

/* 57 - Encuentra el título de todas las películas que fueron alquiladas por más 
de 8 días.*/

with despues_8_días as (
	select i.film_id, (r.return_date - r.rental_date) as dias_alquiler
	from rental r
	inner join inventory i 
		on r.inventory_id = i.inventory_id
	where (r.return_date - r.rental_date) > interval '8 days'
)

select f.title, d.dias_alquiler 
from film f 
inner join despues_8_días d
	on f.film_id = d.film_id
order by d.dias_alquiler asc;

 /* 58 - Encuentra el título de todas las películas que son de la misma categoría 
que ‘Animationʼ. */

select f.title, c.name
from film f 
inner join film_category fc
	on f.film_id = fc.film_id
inner join category c 
	on fc.category_id = c.category_id
where c.name = 'Animation';

/* 59 - Encuentra los nombres de las películas que tienen la misma duración 
que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
alfabéticamente por título de película. */

with misma_duración as (
select "length" as "duracion","title"
from "film" 
where "title"  = 'DANCING FEVER'
)

select "title","length"
from "film" 
where "length" = (select "duracion" from misma_duración)
order by "title" asc;

/* 60 - Encuentra los nombres de los clientes que han alquilado al menos 7 
películas distintas. Ordena los resultados alfabéticamente por apellido. */

select  count (distinct(f.film_id )) as "peliculas_distintas", c.first_name , c.last_name 
from customer c
inner join rental r
	on c.customer_id = r.customer_id
inner join inventory i 
	on r.inventory_id = i.inventory_id
inner join film f 
	on i.film_id = f.film_id 
group by c.first_name,c.last_name 
having count (distinct(f.film_id)) > 6
order by c.last_name asc;


/* 61 -  Encuentra la cantidad total de películas alquiladas por categoría y 
muestra el nombre de la categoría junto con el recuento de alquileres. */
  
select c.name as "Categoria", count(r.rental_id ) as "Total_alquilado"
from rental r
inner join inventory i 
	on r.inventory_id = i.inventory_id
inner join film f 
	on i.film_id = f.film_id
inner join film_category fc
	on f.film_id = fc.film_id
inner join category c 
	on fc.category_id = c.category_id
group by c.name;
	
/* 62 - Encuentra el número de películas por categoría estrenadas en 2006. */

select count (f.film_id), c.name , f.release_year 
from film f 
inner join film_category fc
	on f.film_id = fc.film_id
inner join category c 
	on fc.category_id = c.category_id 
where f.release_year = 2006
group by c.name, f.release_year;

/* 63 - Obtén todas las combinaciones posibles de trabajadores con las tiendas 
que tenemos. */

select s.first_name,s.last_name , s2.store_id
from staff s 
cross join store s2

/* 64 -  Encuentra la cantidad total de películas alquiladas por cada cliente y 
muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
películas alquiladas. */


select c.customer_id, c.first_name ,c.last_name , COUNT(r.rental_id) as "Recuento"
from customer c 
join rental r 
	on c.customer_id = r.customer_id
group by c.customer_id, c.first_name ,c.last_name
order by c.last_name asc;







	





