---EX1
SELECT 
sum(case 
  when device_type='laptop' then 1 else 0
end) laptop_views,
sum(case 
  when device_type='tablet' or device_type='phone' then 1 else 0
end) mobile_views
FROM viewership

---Ex2
select x, y, z,
case
    when (x+y)>z and (x+z)>y and (y+z)>x then 'Yes'
    else 'No'
end triangle
from Triangle

---Ex3
SELECT 
round(
  cast(
    sum(case 
      when (call_category is null) or (call_category='n/a') then 1 else 0
    end)
  as decimal)
  /
  cast(
    count(case_id) 
  as decimal)*100,1)
FROM callers

---Ex4
select name from Customer
where referee_id <>'2' or referee_id is null

---Ex5
select
survived,
sum(case when pclass=1 then 1 end) as first_class,
sum(case when pclass=2 then 1 end) as second_class,
sum(case when pclass=3 then 1 end) as third_class
from titanic
group by survived
