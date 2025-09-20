/*

Cleaning Data in SQL Queries

*/


Select *
From Practice.dbo.[Nashville Housing Data for Data Cleaning]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate
From Practice.dbo.[Nashville Housing Data for Data Cleaning]


Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update [Nashville Housing Data for Data Cleaning]
SET SaleDate = CONVERT(Date,SaleDate)

Select saleDate, CONVERT(Date,SaleDate)
From Practice.dbo.[Nashville Housing Data for Data Cleaning]

-- If it doesn't Update properly

ALTER TABLE [Nashville Housing Data for Data Cleaning]
Add SaleDateConverted Date;

Update [Nashville Housing Data for Data Cleaning]
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From Practice.dbo.[Nashville Housing Data for Data Cleaning]
--Where PropertyAddress is null
order by ParcelID


--Self Join
--pulling out address
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From Practice.dbo.[Nashville Housing Data for Data Cleaning] a
JOIN Practice.dbo.[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Practice.dbo.[Nashville Housing Data for Data Cleaning] a
JOIN Practice.dbo.[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Practice.dbo.[Nashville Housing Data for Data Cleaning]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From Practice.dbo.[Nashville Housing Data for Data Cleaning]


ALTER TABLE Practice.dbo.[Nashville Housing Data for Data Cleaning]
Add PropertySplitAddress Nvarchar(255);

Update Practice.dbo.[Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Practice.dbo.[Nashville Housing Data for Data Cleaning]
Add PropertySplitCity Nvarchar(255);

Update Practice.dbo.[Nashville Housing Data for Data Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From Practice.dbo.[Nashville Housing Data for Data Cleaning]





Select OwnerAddress
From Practice.dbo.[Nashville Housing Data for Data Cleaning]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Practice.dbo.[Nashville Housing Data for Data Cleaning]


ALTER TABLE Practice.dbo.[Nashville Housing Data for Data Cleaning]
Add OwnerSplitAddress Nvarchar(255);

Update Practice.dbo.[Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE Practice.dbo.[Nashville Housing Data for Data Cleaning]
Add OwnerSplitCity Nvarchar(255);

Update Practice.dbo.[Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE Practice.dbo.[Nashville Housing Data for Data Cleaning]
Add OwnerSplitState Nvarchar(255);

Update Practice.dbo.[Nashville Housing Data for Data Cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Practice.dbo.[Nashville Housing Data for Data Cleaning]




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Practice.dbo.[Nashville Housing Data for Data Cleaning]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Practice.dbo.[Nashville Housing Data for Data Cleaning]


Update Practice.dbo.[Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
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

From Practice.dbo.[Nashville Housing Data for Data Cleaning]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From Practice.dbo.[Nashville Housing Data for Data Cleaning]




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From Practice.dbo.[Nashville Housing Data for Data Cleaning]


ALTER TABLE Practice.dbo.[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















