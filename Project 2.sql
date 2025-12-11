---1. Số lượng đơn hàng và số lượng khách hàng mỗi tháng
select 
FORMAT_DATE('%m-%Y', delivered_at) as month_year,
count(distinct user_id) as total_user,
count(distinct order_id) as total_orde
from bigquery-public-data.thelook_ecommerce.orders
where status != 'Cancelled' 
  and delivered_at BETWEEN '2019-01-01' AND '2022-04-30'
group by FORMAT_DATE('%m-%Y', delivered_at) 
order by FORMAT_DATE('%m-%Y', delivered_at) 

---2. Giá trị đơn hàng trung bình và lượng khách hàng mỗi tháng
select 
format_date ('%y-%m', created_at) as month_year,
count(distinct user_id) as distinct_users,
(select sum(sale_price) from bigquery-public-data.thelook_ecommerce.order_items)/count(order_id)
  as average_order_value
from bigquery-public-data.thelook_ecommerce.order_items
where created_at between '2019-01-01' and '2022-04-30'
group by format_date ('%y-%m', created_at)
order by format_date ('%y-%m', created_at)

---3. Nhóm khách hàng theo độ tuổi
create temp table female as
select first_name, last_name, gender, age,
case 
when age=
  (select min(age) 
  from bigquery-public-data.thelook_ecommerce.users
  where gender='F') 
  then 'youngest'
when age =
  (select max(age) 
  from bigquery-public-data.thelook_ecommerce.users
  where gender='F') 
  then 'oldest' 
end as tag
from bigquery-public-data.thelook_ecommerce.users
where gender='F'
  and created_at between '2019-01-01' and '2022-04-30';
create temp table male as
select first_name, last_name, gender, age,
case 
when age=
  (select min(age) 
  from bigquery-public-data.thelook_ecommerce.users
  where gender='M') 
  then 'youngest'
when age =
  (select max(age) 
  from bigquery-public-data.thelook_ecommerce.users
  where gender='M') 
  then 'oldest' 
end as tag
from bigquery-public-data.thelook_ecommerce.users
where gender='M'
  and created_at between '2019-01-01' and '2022-04-30';

select * from female 
where tag is not null
union all
select * from male as b
where tag is not null

4. Top 5 sản phẩm mỗi tháng
select 
format_date ('%y-%m', created_at) as month_year,
b.product_id,
from bigquery-public-data.thelook_ecommerce.order_items as a
where created_at between '2019-01-01' and '2022-04-30'
join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.product_id

5. 
with table1 as
(select 
  extract (month from a.created_at) as month,
  extract (year from a.created_at)  as year,
c.category as product_category,
sum(c.cost) as total_cost,
sum(a.sale_price) as TPV,
count(a.order_id) as TPO,
from bigquery-public-data.thelook_ecommerce.order_items as a
join bigquery-public-data.thelook_ecommerce.orders as b 
on a.order_id=b.order_id
join bigquery-public-data.thelook_ecommerce.products as c 
on a.product_id=c.id
group by 
  extract (month from a.created_at),
  extract (year from a.created_at),
  c.category)
select *,
round(100*(TPV-lag(TPV) over(order by year,month))/lag(TPV) over(order by year,month),2)||'%' as revenue_growth,
round(100*(TPO-lag(TPO) over(order by year,month))/lag(TPO) over(order by year,month),2)||'%' as 
order_growth,
TPV-total_cost as total_profit,
(TPV-total_cost)/total_cost as profit_to_cost_ratio
from table1
order by year, month
