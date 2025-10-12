---Ex1
SELECT b.CONTINENT, 
FLOOR(AVG(a.POPULATION)) as AVR
from CITY as a
inner join COUNTRY as b
on a.COUNTRYCODE=b.CODE
GROUP BY b.CONTINENT
order by b.CONTINENT

---Ex2
SELECT
round(
cast( sum(CASE when a.signup_action='Confirmed' then 1 else 0 end) as decimal) 
/ cast(count(text_id) as decimal),2
) as confirm_rate
from texts as a  
inner join emails as b 
on a.email_id=b.email_id

---Ex3
SELECT  b.age_bucket,
round(sum(case when a.activity_type='send' then a.time_spent else 0 end) *100
/sum(case 
  when a.activity_type='open' then a.time_spent  
  when a.activity_type='send' then a.time_spent
  end),2) as send_perc,
round(sum(case when a.activity_type='open' then a.time_spent else 0 end)*100
/sum(case 
  when a.activity_type='open' then a.time_spent  
  when a.activity_type='send' then a.time_spent
  end),2) as open_perc
FROM activities as a 
inner join age_breakdown as b 
on a.user_id=b.user_id
group by b.age_bucket

---Ex4
SELECT a.customer_id
FROM customer_contracts as a 
left join products as b 
on a.product_id=b.product_id
group by a.customer_id
having count(distinct b.product_category) >=3

---Ex5
select a.employee_id, a.name,
count(b.reports_to) as reports_count,
round(sum(case when b.reports_to is not null then b.age else 0 end)
/count(b.reports_to)) as average_age
from Employees as a
inner join Employees as b
on a.employee_id=b.reports_to
group by a.employee_id, a.name
order by employee_id

---Ex6
select a.product_name,
sum(b.unit) as unit
from Products as a
inner join Orders as b
on a.product_id=b.product_id
where extract(month from b.order_date)=2 
    and extract(year from b.order_date)=2020
group by a.product_name
having sum(b.unit)>=100 

---Ex7 (page was not found)
  
-------MIDTERM TEST
---Ex1
select distinct replacement_cost from film
order by replacement_cost 

---Ex2
select
sum(case when replacement_cost between 9.99 and 19.99 then 1 else 0 end) as low,
sum(case when replacement_cost between 20.00 and 24.99 then 1 else 0 end) as medium,
sum(case when replacement_cost between 25.00 and 29.99 then 1 else 0 end) as high
from film

---Ex3
select a.title, a.length, c.name
from film as a
inner join film_category as b
on a.film_id=b.film_id
inner join category as c
on b.category_id=c.category_id
where (c.name like '%Drama') or (c.name like '%Sports%')
group by a.title, a.length, c.name
order by a.length desc


---Ex4
select c.name,
count(a.title)
from film as a
inner join film_category as b
on a.film_id=b.film_id
inner join category as c
on b.category_id=c.category_id
where (c.name like '%Drama') or (c.name like '%Sports%')
group by c.name
order by count(a.title) desc

---Ex5
select 
concat(b.first_name,' ',b.last_name) as actor_name,
count(a.film_id) as movies
from film_actor as a
inner join actor as b
on a.actor_id=b.actor_id
group by concat(b.first_name,' ',b.last_name)
order by count(a.film_id) desc

---Ex6
select 
sum(case when b.customer_id is null then 1 else 0 end) 
from address as a
left join customer as b
on a.address_id=b.address_id

---Ex7
select a.city,
sum(d.amount)
from city as a
join address as b
on a.city_id=b.city_id
join customer as c
on b.address_id=c.address_id
join payment as d
on c.customer_id=d.customer_id
group by a.city
order by sum(d.amount) desc

---Ex8
select 
concat(a.city,', ',e.country) as information,
sum(d.amount)
from city as a
join address as b
on a.city_id=b.city_id
join customer as c
on b.address_id=c.address_id
join payment as d
on c.customer_id=d.customer_id
join country as e
on a.country_id=e.country_id
group by concat(a.city,', ',e.country)
order by sum(d.amount) 



