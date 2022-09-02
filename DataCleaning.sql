select * from nashvilleHousing


------------------------------------------------------------------------------------------

-- standerdize Date formate

select SaleDateConverted, convert(Date,SaleDate) 
from nashvilleHousing

Update nashvilleHousing
set SaleDate= convert(Date,SaleDate)

alter table nashvilleHousing
Add SaleDateConverted Date

Update NashvilleHousing
Set SaleDateConverted= convert(Date,SaleDate)

-----------------------------------------------------------------------------------------------------------

-- To manage null values in PropertyAddress

select PropertyAddress from nashvilleHousing
where PropertyAddress is null

/*
select * from nashvilleHousing
order by ParcelID
*/
Select a.[UniqueID ],a.ParcelID, a.PropertyAddress,b.[UniqueID ],b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress) 
from nashvilleHousing a
join nashvilleHousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
 from nashvilleHousing a
 join nashvilleHousing b
 on a.ParcelID= b.ParcelID
 and a.[UniqueID ]<> b.[UniqueID ]
 where a.PropertyAddress is null





-------------------------------------------------------------------------------------------------------

 -- Breaking out address into individual column (Address, city ,state)

 select PropertyAddress from nashvilleHousing

 select PropertyAddress, substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address,
 substring(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) as Address
 from nashvilleHousing
 

alter table nashvilleHousing 
add PropertySplitAddress nvarchar(255)

Update nashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',',PropertyAddress) -1) 

/*
alter table nashvilleHousing
drop column if exists PropertySplitCity 
*/

alter table nashvilleHousing
add PropertySplitCity nvarchar(255) 

Update nashvilleHousing
set PropertySplitCity= substring(PropertyAddress,charindex(',',PropertyAddress)+1, len(PropertyAddress))


--using Parsename

select ownerAddress from nashvilleHousing

select PARSENAME(replace(ownerAddress,',','.'),3),
PARSENAME(replace(ownerAddress,',','.'),2),
PARSENAME(replace(ownerAddress,',','.'),1)
from nashvilleHousing


alter table nashvilleHousing
add OwnerSplitAddress nvarchar(255) 

Update nashvilleHousing
set OwnerSplitAddress= PARSENAME(replace(ownerAddress,',','.'),3)

alter table nashvilleHousing
add OwnerSplitCity nvarchar(255) 

Update nashvilleHousing
set OwnerSplitCity= PARSENAME(replace(ownerAddress,',','.'),2)

alter table nashvilleHousing
add OwnerSplitState nvarchar(255) 

Update nashvilleHousing
set OwnerSplitState=PARSENAME(replace(ownerAddress,',','.'),1)

select * from nashvilleHousing


----------------------------------------------------------------------------------------------------

-- change 'Y' and 'N' as Yes and No in sold as vacant column

select distinct(SoldAsVacant),count(SoldAsVacant)  from nashvilleHousing
group by SoldAsVacant 
order by 2


select SoldAsVacant,
Case when SoldAsVacant= 'Y' THEN 'Yes'
     when SoldAsVacant= 'N' THEN 'No'
	 Else SoldAsVacant
	 end
from nashvilleHousing


Update nashvilleHousing 
set SoldAsVacant= Case when SoldAsVacant= 'Y' THEN 'Yes'
     when SoldAsVacant= 'N' THEN 'No'
	 Else SoldAsVacant
	 end

-------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumCTE as (
select *,
	ROW_NUMBER() over(
	partition by
	ParcelID,
	PropertySplitAddress,
	SaleDateConverted,
	OwnerSplitAddress,
	SalePrice,
	LegalReference
	order by ParcelID
	) row_num

from nashvilleHousing
)
select * from RowNumCTE
where row_num>1

 

--to Delete duplicate using CTE and delete statement
with RowNumCTE as (
select *,
	ROW_NUMBER() over(
	partition by
	ParcelID,
	PropertySplitAddress,
	SaleDateConverted,
	OwnerSplitAddress,
	SalePrice,
	LegalReference
	order by ParcelID
	) row_num

from nashvilleHousing
)
Delete from RowNumCTE
where row_num>1

---------------------------------------------------------------------------------------------------

-- delete unused column

Select * from nashvilleHousing
/*
alter table nashvilleHousing
drop column PropertyAddress, SaleDate,OwnerAddress, TaxDistrict
*/
