--tên header bị lặp từ file csv
delete from public.sales_dataset_rfm_prj
where ordernumber !~ '^[0-9]+$'
	and quantityordered !~ '^[0-9]+$'
	and priceeach !~ '^[0-9]+$'
	and orderlinenumber !~ '^[0-9]+$'
	and sales !~ '^[0-9]+$'
	and orderdate !~ '^[0-9]+$'
	and status !~ '^[0-9]+$'
	and productline !~ '^[0-9]+$'
	and msrp !~ '^[0-9]+$'
	and productcode !~ '^[0-9]+$'
	and customername !~ '^[0-9]+$'
	and phone !~ '^[0-9]+$'
	and addressline1 !~ '^[0-9]+$'
	and addressline2 !~ '^[0-9]+$'
	and city !~ '^[0-9]+$'
	and state !~ '^[0-9]+$'
	and postalcode !~ '^[0-9]+$'
	and country !~ '^[0-9]+$'
	and territory !~ '^[0-9]+$'
	and contactfullname !~ '^[0-9]+$'
	and dealsize !~ '^[0-9]+$'

--Chuyển đổi kiểu dữ liệu thích hợp
ALTER TABLE public.sales_dataset_rfm_prj
    ALTER COLUMN ordernumber TYPE integer USING ordernumber::integer,
    ALTER COLUMN quantityordered TYPE integer USING quantityordered::integer,
	alter column priceeach type numeric USING priceeach::numeric,
	alter column orderlinenumber type integer USING orderlinenumber::integer,
	alter column sales type numeric USING sales::numeric,
	alter column orderdate type timestamp using orderdate::timestamp,
	alter column status type varchar(20) using status::varchar(20),
	alter column productline type varchar(20) using productline::varchar(20),
	alter column msrp type integer USING msrp::integer,
	alter column customername type text using customername::text;

--kiểm tra trường bị null/blank	
select * from public.sales_dataset_rfm_prj
where ordernumber is null
	or quantityordered is null
	or priceeach is null
	or orderlinenumber is null
	or sales is null
	or orderdate is null

--tách firstname và lastname từ cột fullname
alter table public.sales_dataset_rfm_prj
add contactlastname varchar(50),
add contactfirstname varchar(50);

update public.sales_dataset_rfm_prj
set
	contactfirstname=initcap(substring(contactfullname from 1 for position('-' in contactfullname)-1)),
	contactlastname=initcap(substring(contactfullname from position('-' in contactfullname)+1 for length(contactfullname)))

--Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE 
alter table public.sales_dataset_rfm_prj
add qtr_id int,
add month_id int,
add year_id int

update public.sales_dataset_rfm_prj
set
	qtr_id=extract(quarter from orderdate),
	month_id=extract(month from orderdate),
	year_id=extract(year from orderdate)

--Tìm oulier cho cột quantityordered 
with max_min as
	(select
	percentile_cont(0.25) within group (order by quantityordered) as q1,
	percentile_cont(0.75) within group (order by quantityordered) as q3,
	percentile_cont(0.25) within group (order by quantityordered)-1.5*(percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered)) as min,
	percentile_cont(0.75) within group (order by quantityordered)+1.5*(percentile_cont(0.75) within group (order by quantityordered)-percentile_cont(0.25) within group (order by quantityordered)) as max
	from public.sales_dataset_rfm_prj)
delete from public.sales_dataset_rfm_prj
where quantityordered<(select min from max_min)
	or quantityordered>(select max from max_min)
