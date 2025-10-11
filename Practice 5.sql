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

