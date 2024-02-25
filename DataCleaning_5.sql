use eee
--Drag each table into the canvas and use a union step to stack them on top of one another
select * 
INTO [dbo].[Customers]
From(
	SELECT * FROM [dbo].[January$]
    UNION
    SELECT * FROM [dbo].[February$]
    UNION
    SELECT * FROM [dbo].[March$]
	UNION
	SELECT * FROM [dbo].[April$]
	UNION 
	SELECT * FROM [dbo].[May$]
	UNION
	SELECT * FROM [dbo].[April$]
	UNION
	SELECT * FROM [dbo].[May$]
	UNION
	SELECT * FROM [dbo].[June$]
	UNION
	SELECT * FROM [dbo].[July$]
	UNION
	SELECT * FROM [dbo].[August$]
	UNION
	SELECT * FROM [dbo].[September$]
	UNION
	SELECT * FROM [dbo].[October$]
	UNION
	SELECT * FROM [dbo].[November$]
	UNION
	SELECT * FROM [dbo].[December$]
) AS nested_union;
select * from Customers
--Some of the fields aren't matching up as we'd expect, due to differences in spelling. Merge these fields together
ALTER TABLE Customers
ADD Demoo nvarchar(255);

UPDATE Customers
SET Demoo = Demographic;

select distinct Account_Type from Customers

UPDATE Customers
SET Account_Type = 
    CASE 
        WHEN Value = 'Platinum' THEN 'Platinum' 
        WHEN Value = 'Gold' THEN 'Gold'
        WHEN Value = 'Basic' THEN 'Basic'
        ELSE 'Default_Account_Type' 
    END;
	
	 alter table Customers
  add New_Acc varchar(55)
UPDATE Customers
SET New_Acc = (
    SELECT TOP 1 Account_Type
    FROM Customers AS C2
    WHERE C2.ID = Customers.ID
);


alter table Customers
add DOB DATE
UPDATE Customers
SET DOB = 
    CASE 
        WHEN ISDATE(Value) = 1 THEN CONVERT(DATE, Value, 101)
		ELSE '1990-01-01'
    END;

	alter table Customers
add DOOB DATE
UPDATE Customers
SET DOOB = (
    SELECT MAX(DOB)
    FROM Customers AS C2
    WHERE C2.ID = Customers.ID
);
-- Update the 'DOOB' column
UPDATE Customers
SET DOOB = NULL
WHERE DOOB = '1990-01-01';


alter table Customers
add Ethinicity nvarchar(56)
UPDATE Customers
SET Ethinicity = 
    CASE 
        WHEN Value = 'Asian' THEN 'Asian'
        WHEN Value = 'Other' THEN 'Other'
        WHEN Value = 'White' THEN 'White'
        WHEN Value = 'Black' THEN 'Black'
        ELSE 'Default_Ethinicity' 
    END;
alter table Customers
add NEW_Eth varchar(55)
UPDATE Customers
SET NEW_Eth = (
    SELECT MAX(Ethinicity)
    FROM Customers AS C2
    WHERE C2.ID = Customers.ID
);




  select count(ID),Ethinicity 
  from Customers
  group by Ethinicity

  alter table Customers
  add New_Ethinicity varchar(55)
UPDATE Customers
SET NEW_Eth = (
    SELECT TOP 1 Ethinicity
    FROM Customers AS C2
    WHERE C2.ID = Customers.ID
      AND C2.Ethinicity != 'Default_Ethinicity'
    ORDER BY C2.Ethinicity DESC  
);
--delete unwanted columns
alter table Customers
drop column Demographic
alter table Customers
drop column Demoo
alter table Customers
drop column DOB
alter table Customers
drop column JoiningDay
SELECT *
FROM Customers
ORDER BY CASE WHEN DateofBirth IS NULL THEN 1 ELSE 0 END, DateofBirth DESC;
	--renaming columns
exec sp_rename 'Customers.[New_Acc]','Account_Type','COLUMN';
exec sp_rename 'Customers.[DOOB]','DateofBirth','COLUMN';
exec sp_rename 'Customers.[NEW_Eth]','Ethinicity','COLUMN';

SELECT 
    JoiningDay,
    DATEADD(DAY, CAST(JoiningDay AS INT) - 1, '2022-01-01') AS ConvertedDate
FROM 
    Customers;
	alter table Customers
	add JoiningDate Date
	update Customers
	set JoiningDate = DATEADD(DAY, CAST(JoiningDay AS INT) - 1, '2022-01-01')
FROM 
    Customers;