set global sql_mode='';

use sakila;

-- Write a query to display for each store its store ID, city, and country
select store_id, ci.city, co.country
from sakila.store s
join sakila.address a on s.address_id = a.address_id
join sakila.city ci on a.city_id = ci.city_id
join sakila.country co on co.country_id = co.country_id;

-- Write a query to display how much business, in dollars, each store brought in
select s.store_id, sum(p.amount)
from sakila.staff s
join sakila.payment p on s.staff_id = p.staff_id
group by s.store_id;

-- What is the average running time of films by category?
select c.name, avg(f.length)
from sakila.category c
join sakila.film_category fc on c.category_id = fc.category_id
join sakila.film f on fc.film_id = f.film_id
group by c.name;

-- Which film categories are longest?
select c.name, max(f.length)
from sakila.category c
join sakila.film_category fc on c.category_id = fc.category_id
join sakila.film f on fc.film_id = f.film_id
group by c.name
order by length desc limit 1;

-- Display the most frequently rented movies in descending order
select f.film_id, count(r.rental_id) as most_frequently_rented
from sakila.film f
join sakila.inventory i on f.film_id = i.film_id
join sakila.rental r on i.inventory_id = r.inventory_id
group by f.film_id
order by most_frequently_rented desc;

-- List the top five genres in gross revenue in descending order
select c.name, sum(p.amount) as amount
from sakila.category c
left join sakila.film_category fc on c.category_id = fc.category_id
left join sakila.inventory i on fc.film_id = i.film_id
left join sakila.rental r on i.inventory_id = r.inventory_id
left join sakila.payment p on r.rental_id = p.rental_id
group by c.name
order by amount desc limit 5;

-- Is "Academy Dinosaur" available for rent from Store 1?
create temporary table tmpry_table as
select distinct(f.film_id), r.inventory_id, max(r.return_date) as return_date
from sakila.film f 
join sakila.inventory i on f.film_id = i.film_id
join sakila.rental r on i.inventory_id = r.inventory_id
where f.film_id = 1 and i.store_id = 1
group by r.inventory_id
order by r.rental_date desc;

select * from tmpry_table;
