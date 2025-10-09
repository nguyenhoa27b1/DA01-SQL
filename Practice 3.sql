---Ex1
select name from STUDENTS
where marks>75
order by right(name,3), ID

---Ex2
select user_id,
concat(upper(left(name,1)),lower(right(name, length(name)-1))) as name
from Users
order by user_id

---Ex3
SELECT manufacturer,
concat('$ ',round(round(sum(total_sales),-6)/1000000,0),' million') as sale
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer

---Ex4
SELECT 
extract(month from submit_date) as mth,
product_id,
round(avg(stars),2) as avg_stars
FROM reviews
group by product_id, extract(month from submit_date)
order by extract(month from submit_date), product_id

---Ex5
SELECT sender_id,
count(message_id) as message_count
FROM messages
where extract(month from sent_date)=8
  and extract(year from sent_date)=2022
group by sender_id
order by count(message_id) desc
limit 2

---Ex6
select tweet_id 
from Tweets
where length(content)>15

---Ex7
select 
activity_date as day,
count(distinct user_id) as active_users
from Activity
where (activity_date between '2019-06-28' and '2019-07-27')
group by activity_date

---Ex8
select 
count(distinct id) as number_eployees
from employees
where (extract(month from joining_date) between 1 and 7)
    and (extract(year from joining_date)=2022)

---Ex9
select first_name,
position('a' in first_name) as position_of_a
from worker;

---Ex10
select 
substring(title from length(winery)+2 for 4)
from winemag_p2
where country='Macedonia'
