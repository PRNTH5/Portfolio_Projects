use [Portfolio_Project]
 --Create the bank code by splitting out off the letters from the Transaction code, call this field 'Bank'

alter table Wk$
add Bank varchar(22)
update WK$
set Bank = left(TransactionCode,CHARINDEX('-',TransactionCode)-1)
alter table Wk$
add Code nvarchar(50)
Update WK$
set Code = SUBSTRING(TransactionCode,CHARINDEX('-',TransactionCode)+1,LEN(TransactionCode)) 

--Change transaction date to the just be the month of the transaction


alter table WK$
add Month Varchar(22)


UPDATE WK$
SET Month = FORMAT(TRY_CAST(TransactionDate AS DATE), 'MMMM')
WHERE ISDATE(TransactionDate) = 1 OR ISDATE(TransactionDate) = 0;

--Total up the transaction values so you have one row for each bank and month combination
select Sum(Value) as Total_Value,Bank,Month
from WK$
group by Bank,Month
order by Month

alter table WK$
add Total_Value int
UPDATE WK$
SET Total_Value = (
    SELECT SUM(Value)
    FROM WK$ AS innerTable
    WHERE innerTable.Bank = WK$.Bank
)


select Bank,Month,Total_Value from WK$

--Rank each bank for their value of transactions 
--each month against the other banks. 1st is the highest value of transactions, 3rd the lowest.
alter table WK$
add Rank_Per_Month int
UPDATE WK$
SET Rank_Per_Month = Ranked.rnk
FROM (
    SELECT Total_Value, Bank, Month,
           DENSE_RANK() OVER (PARTITION BY Month ORDER BY Total_Value DESC ) as rnk
    FROM (
        SELECT DISTINCT Total_Value, Bank, Month
        FROM WK$
    ) AS DistinctValues
) AS Ranked
WHERE WK$.Total_Value = Ranked.Total_Value
    AND WK$.Bank = Ranked.Bank
    AND WK$.Month = Ranked.Month;


	



--The average transaction value per rank, call this field 'Avg Total Value per Rank'


alter table WK$
add Average_Total_Value float


UPDATE WK$
SET Average_Total_Value = Averages.AvgTransactionValue
FROM (
    SELECT Rank_Per_Month, ROUND(AVG(CAST(Total_Value AS decimal(10,2))), 2) AS AvgTransactionValue
    FROM WK$
    GROUP BY Rank_Per_Month
) AS Averages
WHERE WK$.Rank_Per_Month = Averages.Rank_Per_Month;
select *
from WK$
order by Rank_Per_Month ASC, Bank
	--delete unwanted columns
alter table WK$
drop column TransactionCode,Value,CustomerCode,OnlineorInPerson,TransactionDate
alter table WK$
drop column Code


