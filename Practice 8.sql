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
with 
table1 as
    (select visited_on,
    sum(amount) as amount
    from Customer 
    group by visited_on),
table2 as
    (select *,
    round(sum(amount) over(order by visited_on 
        range between interval '6 days' preceding and current row),2) as amount1,
    round(avg(amount) over(order by visited_on 
        range between interval '6 days' preceding and current row),2) as average_amount,
    rank() over(order by visited_on)
    from table1)
select visited_on,
    amount1 as amount,average_amount
from table2
where rank>=7

---Ex5
with
table1 as
    (select pid, tiv_2015, 
    concat(lat,' ',lon) as lat_lon,
    dense_rank() over(order by tiv_2015) ranks
    from Insurance),
table2 as
    (select *,
    case 
        when ranks=lag(ranks) over(order by ranks)
            or ranks=lead(ranks) over(order by ranks)
        then pid else 0
    end id_tiv_2015, ---lọc ra id có tiv_2015 trùng nhau
    case 
        when lat_lon=lag(lat_lon) over(order by lat_lon)
            or lat_lon=lead(lat_lon) over(order by lat_lon)
        then pid else 0
    end id_lat_lon ---lọc ra id có tọa độ khác nhau
    from table1),
table3 as ---lọc id thỏa mãn yêu cầu đề bài
    (select id_tiv_2015
    from table2
    where id_tiv_2015<>0 and id_lat_lon=0)
select 
round(cast(sum(b.tiv_2016) as decimal),2) as tiv_2016
from table3 as a
left join Insurance as b
on a.id_tiv_2015=b.pid 

---Ex6
with 
table1 as --- xếp hạng rank lương mỗi công ty
    (select *,
    dense_rank() over(partition by departmentid order by salary desc) 
    from Employee),
table2 as ---lọc top 3 lương mỗi công ty
    (select * from table1
    where dense_rank<=3) 
select b.name as Department, a.name as Employee, a.salary as Salary
from table2 as a
join Department as b
on b.id=a.departmentid
order by a.id

---Ex7
with
table1 as
    (select *,
    sum(weight) over(order by turn)
    from Queue)
select person_name
from table1
where sum<=1000
order by sum desc
limit 1
