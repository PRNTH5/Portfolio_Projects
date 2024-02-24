use [Portfolio_Project]
select * from [dbo].[SwiftCodes]
select * from [dbo].[Transactions]
exec sp_rename 'Transactions.[Sort Code]','SortCode','COLUMN';
exec sp_rename 'Transactions.[Transaction ID]','TransactionID','COLUMN';
exec sp_rename 'Transactions.[Account Number]','AccountNumber','COLUMN';
exec sp_rename 'SwiftCodes.[SWIFT code]','SwiftCode','COLUMN';
exec sp_rename 'SwiftCodes.[Check Digits]','CheckDigits','COLUMN';
			--In the Transactions table, there is a 
			--Sort Code field which contains dashes. We need to remove these so just have a 6 digit string
select SortCode from [dbo].[Transactions]
alter table [dbo].[Transactions]
add new_SortCode int
update [dbo].[Transactions] 
set new_SortCode = REPLACE(SortCode, '-', '');

			--Use the SWIFT Bank Code lookup table to bring in additional information about 
			--the SWIFT code and Check Digits of the receiving bank account
select s.SwiftCode,
	   s.CheckDigits,
	   t.AccountNumber as ReceivingBankAccount_No,
	   t.new_SortCode
from SwiftCodes s
join Transactions t
on s.Bank=t.Bank
order by s.[CheckDigits]
		--Add a field Country  with Code (Eg UK: G8)
alter table [dbo].[SwiftCodes]
add Country varchar(20)
update [dbo].[SwiftCodes]
set Country= 'G8'

		--Create the IBAN (InternationalBankAccountingNumber) #SwiftCode,#Country,#AccNo
select s.SwiftCode,
	   s.Country,
	   t.AccountNumber,
	 CONCAT(s.Country,s.SwiftCode,(Cast (t.[AccountNumber] as NVarchar))) as IBAN
from SwiftCodes s
join Transactions t
on s.Bank=t.Bank

alter table [dbo].[Transactions]
add IBAN nvarchar(55)
alter table [dbo].[Transactions]
drop column IBAN
UPDATE [dbo].[Transactions]
SET IBAN = CONCAT(s.Country, s.SwiftCode, CAST(t.[AccountNumber] AS nvarchar(55)))
FROM SwiftCodes s
JOIN Transactions t ON s.Bank = t.Bank;


--Remove Unwanted Columns
alter table [dbo].[Transactions] 
drop column SortCode



