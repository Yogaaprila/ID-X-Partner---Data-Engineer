use staging;

Select * from account;

Select * from branch;

Select * from city;

select * from customer;

Select * from state;

-- IMPORT CSV AND EXCEL FILE TO 'STAGING' DATABASE
select * from transaction_csv; --transaction id 14-25
select * from transaction_db; -- transaction id 1-10
select * from transaction_excel ; -- transaction id 6,7,11-15

-- union table transaction_db and transaction_excel and transaction_csv
SELECT * FROM transaction_db
UNION 
SELECT * FROM transaction_excel
UNION
SELECT * FROM transaction_csv;

-- create new combined table
SELECT * INTO transaction_combined
FROM transaction_db
UNION
SELECT * FROM transaction_excel
UNION
SELECT * FROM transaction_csv;

--
select * from transaction_combined 

select count(*)
from transaction_combined 
group by transaction_combined.transaction_id


---
select 
	cs.customer_id,
	cs.customer_name,
	cs.address,cm.city_name,
	cm.state_name,
	cs.age,
	cs.gender,
	cs.email
from customer as cs
left join (select city_id,city_name,ct.state_id,state_name from city as ct
left join state as st on ct.state_id = st.state_id) as cm on cs.city_id = cm.city_id