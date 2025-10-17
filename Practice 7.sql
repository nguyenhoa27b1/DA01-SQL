---Ex1
select 
to_char(transaction_date,'yyyy') as year,
product_id, 
spend as curr_year_spend,
lag(spend) over(partition by product_id order by product_id) as prev_year_spend,
round(100*(spend-lag(spend) over(partition by product_id order by product_id))/ lag(spend) over(partition by product_id order by product_id),2) as yoy_rate
from user_transactions
order by product_id

---Ex2
with 
table1 as
  (SELECT card_name,
  first_value(issue_month) over(partition by card_name order by issued_amount) as first_month
  FROM monthly_cards_issued),
table2 AS
  (select card_name, first_month
  from table1
  group by card_name, first_month)
select b.card_name, a.issued_amount
from monthly_cards_issued as a  
join table2 as b
on a.card_name=b.card_name
  and a.issue_month=b.first_month
order by a.issued_amount desc

---Ex3
select user_id, spend, transaction_date
from
  (SELECT *,
  row_number() over(partition by user_id order by transaction_date)
  FROM transactions) as TABLE1
where row_number=3

---Ex4
with 
table1 as 
  (SELECT *,
  rank() over(partition by user_id order by transaction_date desc),
  row_number() over(partition by user_id order by transaction_date desc)
  FROM user_transactions),
table2 as 
  (SELECT  user_id, count(*)
  from table1
  where rank=1
  group by user_id)
SELECT b.transaction_date, a.user_id, a.count as purchase_count
from table2 as a  
join table1 as b 
on a.user_id=b.user_id
  and b.row_number=1
order by b.transaction_date

---Ex5
SELECT
  user_id,
  tweet_date,
  round(AVG(tweet_count) OVER (
    partition by user_id
    ORDER BY tweet_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
  ),2) AS rolling_avg_3d
FROM tweets

---Ex6
  with 
table1 as
  (SELECT merchant_id,
  lag(merchant_id) over(partition by merchant_id, credit_card_id, amount  order by transaction_timestamp) as pre_merchant,
  credit_card_id,
  lag(credit_card_id) over(partition by merchant_id, credit_card_id, amount  order by transaction_timestamp) as pre_credit,
  amount,
  lag(amount) over(partition by merchant_id, credit_card_id, amount  order by transaction_timestamp) as pre_amount,
  transaction_timestamp - lag(transaction_timestamp) over(partition by merchant_id, credit_card_id, amount  order by transaction_timestamp) as time
  FROM transactions),
table2 AS
  (SELECT *,
  extract(day from time) as day,
  extract(hour from time) as hour,
  extract(minute from time) as minute
  from table1)
select count(*) from table2
where merchant_id=pre_merchant
  and credit_card_id=pre_credit
  and amount=pre_amount
  and day=0
  and hour=0
  and minute<=10
  
---Ex7
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

---Ex8
WITH
table1 AS
  (SELECT c.artist_name,
  count(*)
  from global_song_rank as a 
  join songs as b 
  on a.song_id=b.song_id
  join artists as c
  on b.artist_id=c.artist_id
  where rank<=10
  group by c.artist_name),
table2 as
  (SELECT artist_name, 
  dense_rank() over(order by count desc) as artist_rank
  from table1 
  order by artist_rank)
select artist_name,  artist_rank
from table2
where artist_rank<=5
