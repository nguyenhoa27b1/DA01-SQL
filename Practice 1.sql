---Ex1
SELECT NAME FROM CITY
WHERE COUNTRYCODE = 'USA'
  AND POPULATION > 120000

---Ex2
SELECT * FROM CITY
WHERE COUNTRYCODE='JPN'

---Ex3
SELECT CITY, STATE FROM STATION

---Ex4
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) IN ('i','e','a','o','u')

---Ex5
SELECT DISTINCT CITY FROM STATION
WHERE RIGHT(CITY,1) IN ('a','e','i','o','u')

---Ex6
SELECT DISTINCT CITY FROM STATION
WHERE LEFT(CITY,1) NOT IN ('u','e','o','a','i')

---Ex7
SELECT name FROM Employee
order by name

---Ex8
select name from Employee
where salary>2000 and months<10
order by employee_id

---Ex9
select product_id from Products
where low_fats = 'Y' and recyclable = 'Y'

---Ex10
select name from Customer
where referee_id <>'2' or referee_id is null

---Ex11
select name,population,area from World
where area>=3000000 or population>=25000000

---Ex12
select distinct author_id as id from Views
where viewer_id=author_id
order by author_id asc

---Ex13
SELECT part,assembly_step FROM parts_assembly
WHERE finish_date is null

---Ex14
select * from lyft_drivers
where yearly_salary <= 30000 or yearly_salary >= 70000

---Ex15
select * from uber_advertising
where money_spent >= 100000 and year = 2019
