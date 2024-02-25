use [Portfolio_Project]
select * from [dbo].[Week1$]
select * from [dbo].[Targets$]
--Filter the transactions to just look at DSB
alter table Week1$
add  Code Nvarchar(255)
update Week1$
set TCode = TransactionCode where TransactionCode LIKE 'DSB%'

--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values

select OnlineorInPerson, Value from Week1$

select OnlineorInPerson,
	case	
		When OnlineorInPerson = 1 then 'Online'
		When OnlineorInPerson = 2 then	'InPerson'  End 
		from Week1$
alter table Week1$
add OnlineorInPersonNew nvarchar(222)
update Week1$
set OnlineorInPersonNew = case	
		When OnlineorInPerson = 1 then 'Online'
		When OnlineorInPerson = 2 then	'InPerson'  End 
		from Week1$

		--Change the date to be the quarter

	alter table Week1$
	add new nvarchar(MAX)
UPDATE Week1$
SET new = 
    CASE 
        WHEN ISDATE(TransactionDate) = 1 THEN CONVERT(NVARCHAR, CAST(TransactionDate AS DATE), 103)
        ELSE TransactionDate
    END;

alter table Week1$
add Quarter_N int
UPDATE Week1$
SET Quarter_N = 
    COALESCE(
        
        CASE WHEN ISDATE(new) = 1 THEN DATEPART(QUARTER, TRY_CAST(new AS DATE)) END,
       
        TRY_CAST(new AS INT),
   
        0  
    )
WHERE ISDATE(new) = 1 OR TRY_CAST(new AS INT) IS NOT NULL;

--Sum the transaction values for each quarter and for each Type of Transaction (Online or In-Person) 
select Sum(Value), OnlineorInPersonNew,Quarter_N from Week1$
group by OnlineorInPersonNew, Quarter_N

alter table Week1$
add TotalValue int
UPDATE Week1$
SET TotalValue = t.SumValue
FROM (
    SELECT 
        OnlineorInPersonNew,
        Quarter_N,
        SUM(Value) AS SumValue
    FROM 
        Week1$
    GROUP BY 
        OnlineorInPersonNew, 
        Quarter_N
) t
WHERE 
    Week1$.OnlineorInPersonNew = t.OnlineorInPersonNew
    AND Week1$.Quarter_N = t.Quarter_N;


	select * from Week1$;
	select * from Targets$;

	--Join the two datasets together
	--joining two tables 'week1$' and 'targets$' and insert them in a new table
select * into new_tab(
select w.OnlineorInPerson,w.Quarter_N,w.TotalValue,t.Q1,t.Q2,t.Q3,t.Q4,
case 
	when w.Quarter_N = 1 then t.Q1 
	when w.Quarter_N = 2 then t.Q2
	when w.Quarter_N = 3 then t.Q3
	when w.Quarter_N = 4 then t.Q4
end as Quarterly_Targets
from Week1$ w
join Targets$ t
on w.OnlineorInPerson = t.[OnlineorInPerson]
)

--delete unwanted columns
	alter table Week1$
	drop column OnlineorInPerson
	alter table Week1$
	drop column TransactionDate
	alter table Week1$
	drop column TransactionCode
	alter table Week1$
	drop column Value
	delete from Week1$
where Quarter_N is null
	alter table new_tab
	drop column Q1,Q2,Q3,Q4
	--renamaing columns
exec sp_rename 'Week1$.[OnlineorIn-Person]','OnlineorInPerson','Column';

exec sp_rename 'Targets$.[OnlineorIn-Person]','OnlineorInPerson','Column';