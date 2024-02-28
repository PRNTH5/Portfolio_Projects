use [Clean]
 	--adjust fields in fullname
alter table [dbo].[club_member_info$]
add new_full varchar(56)
update [dbo].[club_member_info$]
SET new_full = LTRIM(RTRIM(full_name))
select full_name, new_full from [dbo].[club_member_info$]
alter table [dbo].[club_member_info$]
add new_fullname varchar(56)
update [dbo].[club_member_info$]
SET new_fullname = REPLACE(new_full,'???','') from [dbo].[club_member_info$]

select new_fullname, UPPER(LEFT(new_fullname,1))+Lower(Right(new_fullname,LEN(new_fullname	)-1)) from [dbo].[club_member_info$]
alter table [dbo].[club_member_info$]
add Full_name varchar(56)
Update [dbo].[club_member_info$]
set Full_name =UPPER(LEFT(new_fullname,1))+Lower(Right(new_fullname,LEN(new_fullname	)-1)) from [dbo].[club_member_info$]

		--remove null values in martial status
select distinct martial_status from [dbo].[club_member_info$]
delete from [dbo].[club_member_info$]
where martial_status is null
		--format date
select membership_date from [dbo].[club_member_info$]
alter table [dbo].[club_member_info$]
add  new_date date
update [dbo].[club_member_info$]
set new_date = CONVERT(date,membership_date) from [dbo].[club_member_info$]

		--split full_address into address, city, state
select full_address from [dbo].[club_member_info$]
alter table [dbo].[club_member_info$]
add Address nvarchar(55)
update [dbo].[club_member_info$]
set Address = 	PARSENAME(REPLACE(full_address, ',','.'),3)
alter table [dbo].[club_member_info$]
add City nvarchar(55)
update [dbo].[club_member_info$]
set City = PARSENAME(REPLACE(full_address, ',','.'),2)
alter table [dbo].[club_member_info$]
add State nvarchar(55)
update [dbo].[club_member_info$]
set  State= PARSENAME(REPLACE(full_address, ',','.'),1)

		-- identify and remove if there are any more null values
		-- age, phone, jobtitle
	DELETE FROM [dbo].[club_member_info$]
	WHERE phone IS NULL
	DELETE FROM [dbo].[club_member_info$]
	WHERE age IS NULL
	DELETE FROM [dbo].[club_member_info$]
	WHERE job_title IS NULL
select * from [dbo].[club_member_info$]
			--delete unwanted columns
alter table [dbo].[club_member_info$]
drop column full_name,new_full
alter table [dbo].[club_member_info$]
drop column new_fullname
alter table [dbo].[club_member_info$]
drop column membership_date
alter table [dbo].[club_member_info$]
drop column full_address
			--rename columns
EXEC sp_rename '[dbo].[club_member_info$].[new_date]', 'Date', 'COLUMN';
			
			select * from [dbo].[club_member_info$]	order by Age		