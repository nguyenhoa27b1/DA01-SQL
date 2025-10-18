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
with 
table1 as
    (select player_id,
    first_value(event_date) over(partition by player_id order by event_date) as first_day,
    lead(event_date) over(partition by player_id order by event_date) as next_day
    from Activity)
select 
round(cast(sum(case when (next_day-first_day)=1 then 1 else 0 end) as decimal)/cast(count(distinct player_id) as decimal),2) as fraction
from table1

---Ex3
with table1 as 
    (select *,
    case 
        when id%2=1 then lead(student) over(order by id)
        when id%2=0 then lag(student) over(order by id)
    end name_student
    from Seat)
select id,
coalesce(name_student,student) as student
from table1

---Ex4
