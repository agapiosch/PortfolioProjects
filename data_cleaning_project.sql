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



-- Change the empty values to Null values

update nashville_housing
set PropertyAddress=Null 
where length(propertyAddress)=0;



select parcelid, propertyaddress
from nashville_housing
where propertyaddress is null;



select a.UniqueID, a.ParcelID , a.PropertyAddress,b.UniqueID, b.ParcelID, b.PropertyAddress, coalesce(a.PropertyAddress, b.propertyAddress)
FROM nashville_housing a
JOIN nashville_housing b
ON a.parcelID = b.parcelID
AND a.uniqueID != b.uniqueID
WHERE a.propertyAddress is null;




update nashville_housing a
JOIN nashville_housing b
ON a.parcelID = b.parcelID
AND a.UniqueID != b.UniqueID
set a.propertyAddress = coalesce(a.PropertyAddress, b.PropertyAddress)
WHERE a.propertyAddress is NULL;







--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM nashville_housing;


SELECT SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') -1 ) as Address,
SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1 , LENGTH(PropertyAddress)) as City
FROM nashville_housing;


ALTER TABLE nashville_housing
Add PropertySplitAddress Nvarchar(255);

UPDATE nashville_housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, INSTR(PropertyAddress, ',') -1 );


ALTER TABLE nashville_housing
Add PropertySplitCity Nvarchar(255);

UPDATE nashville_housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, INSTR(PropertyAddress, ',') + 1 , LENGTH(PropertyAddress));



SELECT  *
FROM nashville_housing;





SELECT OwnerAddress
FROM nashville_housing;


SELECT
SUBSTRING_INDEX(OwnerAddress, ',', 1),
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1),
SUBSTRING_INDEX(OwnerAddress, ',', -1)
FROM nashville_housing;




ALTER TABLE nashville_housing
Add OwnerSplitAddress Nvarchar(255);

Update nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);



ALTER TABLE nashville_housing
Add OwnerSplitCity Nvarchar(255);

Update nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);



ALTER TABLE nashville_housing
Add OwnerSplitState Nvarchar(255);

Update nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);



Select *
From nashville_housing;



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nashville_housing
Group by SoldAsVacant
order by 2;




Select SoldAsVacant, 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
     WHEN SoldAsVacant = 'N' THEN 'No'
     ELSE SoldAsVacant
     END
From nashville_housing;


Update nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	   WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;






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
Order by PropertyAddress;








WITH RowNumCTE AS(
Select *,
	row_number() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
                 SaleDate,
				 SalePrice,
				 LegalReference
				 ORDER BY UniqueID ) row_num
From nashville_housing
)

DELETE
From nashville_housing
USING nashville_housing
JOIN RowNumCTE
ON nashville_housing.uniqueID = RowNumCTE.UniqueID
Where rownumCTE.row_num > 1;







Select *
From nashville_housing;





---------------------------------------------------------------------------------------------------------



-- Delete Unused Columns



Select *
From nashville_housing


ALTER TABLE nashville_housing
DROP OwnerAddress, DROP TaxDistrict, DROP PropertyAddress;

SELECT * from nashville_housing;


