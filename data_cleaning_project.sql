/*

Cleaning Data in SQL Queries

*/


SELECT *
FROM nashville_housing;

--------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address data

SELECT *
FROM nashville_housing
ORDER BY ParcelID;



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM nashville_housing a
JOIN nashville_housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM nashville_housing a
JOIN nashville_housing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS null;




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM nashville_housing;


SELECT SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') -1 ) as Address,
SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1 , LEN(PropertyAddress)) as Address
FROM nashville_housing;


ALTER TABLE nashville_housing
Add PropertySplitAddress Nvarchar(255);

UPDATE nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') -1 )


ALTER TABLE nashville_housing
Add PropertySplitCity Nvarchar(255);

UPDATE nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1 , LEN(PropertyAddress));



SELECT  *
FROM nashville_housing;





SELECT OwnerAddress
FROM nashville_housing;


SELECT
SUBSTRING_INDEX(OwnerAddress, ',', 1),
SUBSTRING_INDEX(OwnerAddress, ',', 2),
SUBSTRING_INDEX(OwnerAddress, ',', 3)
FROM nashville_housing;



ALTER TABLE nashville_housing
Add OwnerSplitAddress Nvarchar(255);

Update nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1)


ALTER TABLE nashville_housing
Add OwnerSplitCity Nvarchar(255);

Update nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX(OwnerAddress, ',', 2)



ALTER TABLE nashville_housing
Add OwnerSplitState Nvarchar(255);

Update nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', 3)



Select *
From nashville_housing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Pnashville_housing
Group by SoldAsVacant
order by 2




Select SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END
From nashville_housing


Update nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From nashville_housing
)

Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From nashville_housing




---------------------------------------------------------------------------------------------------------



-- Delete Unused Columns



Select *
From nashville_housing


ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



