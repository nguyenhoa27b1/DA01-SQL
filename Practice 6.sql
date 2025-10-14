---EX1
WITH table1 as
  (select company_id, title, description,
  count(*)
  from job_listings
  group by company_id, title, description
  having count(*)>1)
SELECT count(*) as duplicate_companies from table1

  ---Ex2
WITH ranked_products AS (
    SELECT 
        category,
        product,
        SUM(spend) AS total_spend,
        RANK() OVER (
            PARTITION BY category
            ORDER BY SUM(spend) DESC
        ) AS rank_in_category
    FROM product_spend
    WHERE EXTRACT(YEAR FROM transaction_date) = 2022
    GROUP BY category, product
)
SELECT 
    category,
    product,
    total_spend 
FROM ranked_products
WHERE rank_in_category <= 2
ORDER BY category, total_spend DESC;

---Ex3
select count(*) from 
  (select policy_holder_id, count(*)
  from callers
  group by policy_holder_id
  having count(*)>=3) as a 

  ---Ex4
with table1 as
  (select a.page_id as aa, b.page_id as bb 
  from pages as a  
  left join page_likes as b  
  on a.page_id=b.page_id)
SELECT 
aa 
from table1
where bb is null 
order by aa 

  ---Ex5
With table1 
  as 
(SELECT user_id,
  sum(case WHEN
      (event_type='sign-in')
      or (event_type='like')
      or (event_type='comment')
    then 1 else 0
    end) as active_7
  FROM user_actions
  where extract(month from event_date)=7
  group by user_id),
table2 
as 
(SELECT user_id,
  sum(case WHEN
      (event_type='sign-in')
      or (event_type='like')
      or (event_type='comment')
    then 1 else 0
    end) as active_6
  FROM user_actions 
  where extract(month from event_date)=6
  group by user_id)
select 7 as month,
count(*) as monthly_active_users
from table1 as a  
join table2 as b  
on a.user_id=b.user_id

---Ex6
select
    to_char(trans_date,'yyyy-mm') as month,
    country,
    count(*) as trans_count,
    sum(case when state='approved' then 1 else 0 end) as approved_count,
    sum(amount) as trans_total_amount,
    sum(case when state='approved' then amount else 0 end) as approved_total_amount
from Transactions
group by to_char(trans_date,'yyyy-mm'), country

---Ex7
 With table1 as   
    (select product_id, 
    min(year) as first_year
    from Sales
    group by product_id
    order by product_id)
select a.product_id, a.first_year, b.quantity, b.price
from Table1 as a
inner join Sales as b
on a.product_id=b.product_id
    and a.first_year=b.year

---Ex8
select customer_id
from Customer 
group by customer_id
having count(distinct product_key)=(select count(distinct product_key) from Product)

---Ex9
With table1 as
    (select *
    from Employees
    where salary<30000 and manager_id is not null)
Select a.employee_id
from table1 as a
left join Employees as b
on a.manager_id=b.employee_id
where b.employee_id is null
order by a.employee_id

---Ex10
WITH table1 as
  (select company_id, title, description,
  count(*)
  from job_listings
  group by company_id, title, description
  having count(*)>1)
SELECT count(*) as duplicate_companies from table1

---Ex11
with
table1 as
    (select user_id,
    count(*) as count_rating
    from MovieRating
    group by user_id),
table2 as
    (select b.name 
    from table1 as a
    join Users as b
    on a.user_id=b.user_id
    where count_rating=(select max(count_rating) from table1)
    order by name
    limit 1),
table3 as
    (select a.movie_id, b.title
    from MovieRating as a
    join Movies as b
    on a.movie_id=b.movie_id
    where to_char(created_at,'yyyy-mm')='2020-02'
    group by a.movie_id, b.title
    order by avg(a.rating) desc, b.title
    limit 1)
select name as results from table2
union all
select title from table3

---Ex12
with
table1 as
    (select requester_id as id from RequestAccepted
    union
    select accepter_id from RequestAccepted),
table2 as
    (select requester_id,
    count(*) as count_request
    from RequestAccepted
    group by requester_id),
table3 as
    (select accepter_id,
    count(*) as count_accept
    from RequestAccepted
    group by accepter_id)
select id,
coalesce(count_request,0) + coalesce(count_accept,0) as num
from table1 as a
left join table2 as b
on a.id=b.requester_id
left join table3 as c
on a.id=c.accepter_id
order by coalesce(count_request,0) + coalesce(count_accept,0) desc
limit 1
