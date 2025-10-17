---Ex1
with 
first as
    (select customer_id,
    first_value(delivery_id) over(partition by customer_id order by order_date) as delivery_id
    from Delivery),
table1 as
    (select a.delivery_id, b.order_date, b.customer_pref_delivery_date
    from first as a
    join Delivery as b
    on a.delivery_id=b.delivery_id
    group by a.delivery_id,b.order_date, b.customer_pref_delivery_date)
select
round(100*cast(sum(case when order_date=customer_pref_delivery_date then 1 else 0 end) as decimal)/cast(count(distinct delivery_id) as decimal),2) as immediate_percentage
from table1

---Ex2
