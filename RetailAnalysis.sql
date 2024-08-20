-- Remove duplicates 
select TransactionID , count(*)
from sales_transaction
group by TransactionID
having count(*) > 1 ;

create table s as 
select distinct transactionID , CustomerID , ProductID , QuantityPurchased , TransactionDate , Price 
from sales_transaction ;

drop table sales_transaction ;

alter table s 
rename to sales_transaction ;

select * from sales_transaction ;

-- to find incorrect prices 

select distinct  pd_in.ProductID , pd_in.Price ,st.Price  from 
sales_transaction as st 
join Product_inventory as pd_in 
on st.ProductID =pd_in.ProductID
where pd_in.Price <> st.Price  ;

-- Fix incorrect  pricing while adressing future problems as well 

update sales_transaction as st
set price = ( select pi.price from Product_inventory pi where pi.ProductID = st.ProductID)
where st.ProductID in -- will give us all the product id with prices 
 (select pi.ProductID from Product_inventory pi where  st.price<> pi.price)
 ;

-- checking the results after the fix 

select * from sales_transaction
where ProductID = 51 ;

-- Finding missing values 

select * from customer_profiles 
where CustomerID is null or age is null or gender is null or location is null or JoinDate is null ;

select count(*) 
from customer_profiles 
where location is  null ;


-- Fixing null values 

update customer_profiles 
set location = 'unknown'
where location is null ;

select * from customer_profiles ;


-- Cleaning date 



-- Step 1: Add a new column with DATE type
ALTER TABLE sales_transaction ADD COLUMN TransactionDate_updated DATE;

-- Step 2: Populate the new column with converted date values
UPDATE sales_transaction 
SET TransactionDate_updated = STR_TO_DATE(TransactionDate, '%Y-%m-%d');

-- Optional Step 3: Drop the original TEXT column if no longer needed
ALTER TABLE sales_transaction DROP COLUMN TransactionDate;

-- Optional Step 4: Rename the new column to the original name
ALTER TABLE sales_transaction RENAME COLUMN TransactionDate_updated TO TransactionDate;

-- OR 

Create table Sales_transaction1
 as select TransactionID ,  CustomerID , ProductID ,QuantityPurchased ,
  TransactionDate, Price , str_to_date(TransactionDate , '%Y-%m-%d' )  as TransactionDate_updated
from sales_transaction ;

drop table  Sales_transaction ;

alter table  Sales_transaction1
rename to sales_transaction;

select* from sales_transaction;


-- Total sales summary 

select ProductID , sum(QuantityPurchased) as TotalUnitsSold ,
sum(QuantityPurchased * Price) as TotalSales 
from Sales_transaction 
group by 1 
order by 3 desc ;

-- Customer  purchase frequency 
select CustomerID , count(TransactionID) as NumberOfTransactions 
from Sales_transaction
group by CustomerID
order by 2 desc  ;

-- Product category performance 
select pi.Category , sum(st.QuantityPurchased) as TotalUnitsSold  , 
sum(st.QuantityPurchased*st.Price) as Totalsales
from Sales_transaction as st 
join  product_inventory as pi on st.ProductID = pi.ProductID
group by 1 
order by 3 desc ;

-- High sales product 
select ProductID, 
sum(QuantityPurchased*Price) as TotalRevenue
from Sales_transaction 
group by 1 
order by 2 desc ;


-- Low sales product 
select ProductID, 
sum(QuantityPurchased) as TotalUnitsSold
from Sales_transaction 
group by 1 
having sum(QuantityPurchased) >= 1
order by 2  
limit 10 ;


-- Sales trends 
select TransactionDate_updated as DATETRANS , count(TransactionID) as Transaction_count,
sum(QuantityPurchased) as TotalUnitsSold , sum(QuantityPurchased*Price) as TotalSales
 from sales_transaction
group by 1 
order by 1 desc ;

-- Growth rate of sales 
with s as 
(select month(TransactionDate_updated) as month , 
sum(QuantityPurchased*Price) as total_sales
 from sales_transaction 
 group by 1 )
 
 
 select * , lag(total_sales) over ( order by  month ) as previous_month_sales ,
 (total_sales-lag(total_sales) over ( order by  month )) /
 lag(total_sales) over ( order by  month ) * 100 as mom_growth_percentage
 from s
 order by month 

-- High purchase frequency 
select  CustomerID , Count(*) as NumberofTransactions , 
sum(Price*QuantityPurchased) as TotalSpent
from sales_transaction
group by CustomerID having  NumberofTransactions > 10 and TotalSpent > 1000
order by TotalSpent desc ;

-- Occasional customer 
select CustomerID , Count(*) as NumberofTransactions , 
sum(Price*QuantityPurchased) as TotalSpent
from sales_transaction
group by CustomerID having  NumberofTransactions <=2
order by NumberofTransactions , TotalSpent desc ;

-- Repeate purchases 
select CustomerID , ProductID , count(*) as TimesPurchased 
from Sales_transaction 
group by 1,2
having count(*)>1
order by 3 desc ; 


-- Loyalty indicators 
With transcationDate as (select CustomerID , 
str_to_date(TransactionDate , '%Y-%m-%d') as TransactionDate 
From Sales_transaction 
)
select CustomerID , 
Min(TransactionDate) as FirstPurchase ,
Max(TransactionDate) as LastPurchase,
datediff( Max(TransactionDate), Min(TransactionDate) ) as DaysBetweenPurchases
from transcationDate
Group by 1 
Having (Max(TransactionDate)  - Min(TransactionDate) ) >0 
order by 4 desc ;


-- Customer segmentation 

Create table customer_segment as 

select CustomerID , 
case when TotalQuantity > 30 then "High"
when TotalQuantity between 10 and 30 then "Mid"
when TotalQuantity between 1 and 10 then "Low"
else "none" end as CustomerSegment
from
(select cp.CustomerID , sum(st.QuantityPurchased) as TotalQuantity 
from customer_profiles as cp 
join sales_transaction as st 
on cp.CustomerID = st.CustomerID 
group by cp.CustomerID ) a ; 

select CustomerSegment , count(*) from customer_segment 
group by 1;



