---Ex1
select DISTINCT CITY from STATION
WHERE MOD(ID,2)=0

---Ex2
select 
count(city) - count(distinct city) as difference
from STATION

---Ex3

  ---Ex4
SELECT 
  round(sum(item_count*order_occurrences)/sum(order_occurrences),1) as mean
FROM items_per_order

  ---Ex5
SELECT candidate_id FROM candidates
where skill in ('Python', 'Tableau','PostgreSQL')
group by candidate_id
having count(distinct skill)=3

---Ex6
SELECT user_id,
  max(date(post_date)) - min(date((post_date))) as days_between
FROM posts
where date(post_date) between '2021-01-01' and '2021-12-31'
group by user_id 
having count( distinct date(post_date))>=2
order by user_id

---Ex7
SELECT card_name,
  max(issued_amount) - min(issued_amount) as difference
FROM monthly_cards_issued
group by card_name
order by difference desc

---Ex8
SELECT manufacturer,
  sum(cogs-total_sales) as total_loss,
  count(distinct drug) as drug_count
FROM pharmacy_sales
where (cogs-total_sales)>0
group by manufacturer
order by total_loss desc

---Ex9
select * 
from cinema
where (mod(id,2)=1) and (description not like '%boring%')
order by rating desc

---Ex10
select teacher_id, 
count(distinct subject_id) as cnt 
from teacher 
group by teacher_id 
order by teacher_id

---Ex11 (lỗi link)
---Ex12 (lỗi link)
