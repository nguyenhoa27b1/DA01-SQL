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
