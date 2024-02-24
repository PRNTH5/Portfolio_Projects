use [Portfolio_Project]
--exec sp_rename 'TransactionsInput.[Customer Code]','CustomerCode','Column';
select * from TransactionsInput
/*split the Transaction Code to extract the letters at the start of the transaction code. 
These identify the bank who processes the transaction whats the meaning*/
	--exec sp_rename 'TransactionsInput.[Transaction Code]','TransactionCode','Column';
alter table TransactionsInput
add Bank_Code varchar(56)
update TransactionsInput
set Bank_Code =LEFT(TransactionCode, CHARINDEX('-', TransactionCode) - 1) 
alter table TransactionsInput
add mod_Code varchar(56)
update TransactionsInput
set mod_Code=SUBSTRING(TransactionCode, CHARINDEX('-', TransactionCode) + 1, LEN(TransactionCode)) 

--Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
    ---exec sp_rename 'TransactionsInput.[Online or In-Person]','OnlineorInPerson','Column';

alter table [dbo].[TransactionsInput]
add Online varchar(25)
  --exec sp_rename 'TransactionsInput.[Online]','OnlineorInPersonNew','Column';

update [dbo].[TransactionsInput]
set OnlineorInPersonNew=Case 
	When OnlineorInPerson=1 then 'Online'
	When OnlineorInPerson=2 then 'In-Person'
	End

	---Total Values of Transactions by each bank
	---Total Values by Bank, Date and Type of Transaction (Online or In-Person)
	---Total Values by Bank and Customer Code
	alter table [dbo].[TransactionsInput]
	add TotalValues int
UPDATE [dbo].[TransactionsInput]
SET TotalValues = (
    SELECT SUM(Value) OVER (PARTITION BY OnlineorInPersonNew ORDER BY TransactionDate)
    FROM [dbo].[TransactionsInput] AS T2
    WHERE T2.Bank_Code = [dbo].[TransactionsInput].Bank_Code
      AND T2.OnlineorInPersonNew = [dbo].[TransactionsInput].OnlineorInPersonNew
      AND T2.TransactionDate = [dbo].[TransactionsInput].TransactionDate
      AND T2.Value = [dbo].[TransactionsInput].Value
)

--delete unwanted columns
	alter table [dbo].[TransactionsInput]
	drop column TransactionCode,OnlineorInPerson
	alter table [dbo].[TransactionsInput]
	drop column Value
				-----CHANGING THE ORDER OF COLUMNS ( Not mandatory but I want my data to be clear)
ALTER TABLE [dbo].[TransactionsInput]
    ADD NewCustomerCode VARCHAR(255);
ALTER TABLE [dbo].[TransactionsInput]
    ADD NewBankCode VARCHAR(255);

ALTER TABLE [dbo].[TransactionsInput]
    ADD NewModCode VARCHAR(255);

ALTER TABLE [dbo].[TransactionsInput]
    ADD NewTransactionDate VARCHAR(255);

ALTER TABLE [dbo].[TransactionsInput]
    ADD NewOnlineorInPersonNew VARCHAR(255);

ALTER TABLE [dbo].[TransactionsInput]
    ADD NewTotalValues VARCHAR(255);

UPDATE [dbo].[TransactionsInput]
SET 
    NewCustomerCode = CustomerCode
UPDATE [dbo].[TransactionsInput]
set 
	NewBankCode = Bank_Code,
    NewModCode = mod_Code,
    NewTransactionDate = TransactionDate,
    NewOnlineorInPersonNew = OnlineorInPersonNew,
    NewTotalValues = TotalValues;

	ALTER TABLE [dbo].[TransactionsInput]
    DROP COLUMN CustomerCode, Bank_Code, mod_Code,TransactionDate,OnlineorInPersonNew,TotalValues;
EXEC sp_rename 'TransactionsInput.NewCustomerCode', 'CustomerCode', 'COLUMN';
EXEC sp_rename 'TransactionsInput.NewBankCode', 'Bank_Code', 'COLUMN';
EXEC sp_rename 'TransactionsInput.NewModCode', 'Mod_Code', 'COLUMN';
EXEC sp_rename 'TransactionsInput.NewTransactionDate', 'TransactionDate', 'COLUMN';
EXEC sp_rename 'TransactionsInput.NewOnlineorInPersonNew', 'OnlineorInPersonNew', 'COLUMN';
EXEC sp_rename 'TransactionsInput.NewTotalValues', 'TotalValues', 'COLUMN';



