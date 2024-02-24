use [Portfolio_Project]
select * from Sheet1
--cleaning data
--standardise date format
alter table Sheet1
Add Sale_Date date
update Sheet1
set Sale_Date=CONVERT(date,SaleDate)

----populate Address
select PropertyAddress from Sheet1
where PropertyAddress is null
update a
set PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from Sheet1 a 
join Sheet1 b
on a.ParcelID = b.ParcelID
 and a.UniqueID<>b.UniqueID
select PropertyAddress from Sheet1 where PropertyAddress is null

--breaking out Address into Individual Columns(Address,City,State)
--Property Address
 select PropertyAddress from Sheet1
alter table Sheet1 
add Property_Address Nvarchar(255)
update Sheet1
set Property_Address=SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

alter table Sheet1
add City_Address Nvarchar(255)
update Sheet1
set City_Address=Substring(PropertyAddress,CharIndex(',',PropertyAddress)+1,LEN(PropertyAddress))

--Owner Address
select OwnerAddress from Sheet1


alter table Sheet1
add Address nvarchar(255)
update Sheet1
set Address = PARSENAME(Replace(OwnerAddress, ',', '.'),3) 
alter table Sheet1
add City nvarchar(255)
update Sheet1
set City=PARSENAME(Replace(OwnerAddress, ',', '.'),2)
alter table Sheet1
add State nvarchar(255)
update Sheet1
set State=PARSENAME(Replace(OwnerAddress, ',', '.'),1)


--change Y and N to Ye and No in "Sold as Vacant"

alter table Sheet1
add new_SoldAsVacant nvarchar(255)
update Sheet1
set new_SoldAsVacant = Case 
	When SoldAsVacant = 'Y' then 'Yes'
	When SoldAsVacant= 'N' then 'No'
	Else SoldAsVacant
	End
from Sheet1

--Remove Duplicates
WITH RowCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         LegalReference
            ORDER BY UniqueID
        ) AS rownum
    FROM Sheet1
)
/*Delete
FROM RowCTE
where rownum>1;*/
Select *
from RowCTE
where rownum>1


--delete unused columns(Property address, soldasvacant,owneraddress,saledate)
alter table Sheet1
drop column PropertyAddress, SoldAsVacant,OwnerAddress,SaleDate