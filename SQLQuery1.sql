SELECT * FROM blinkit_data
SELECT COUNT(*) FROM blinkit_data 

UPDATE blinkit_data
SET Item_Fat_Content = 
CASE WHEN Item_Fat_Content IN ('LF' , 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data
/*total sales,avg sales,no of items,avg rating*/
SELECT 
    CAST(CAST(SUM(Sales) / 1000000.0 AS DECIMAL(10, 2)) AS VARCHAR(20)) + ' millions' AS total_sales_millions
FROM 
    blinkit_data WHERE Item_Fat_Content = 'Low Fat'

SELECT CAST(AVG(Sales) AS DECIMAL(10,0)) AS Avg_sales FROM blinkit_data WHERE Outlet_Establishment_Year = 2022
SELECT COUNT(*) AS no_of_items FROM blinkit_data
WHERE Outlet_Establishment_Year = 2022
SELECT CAST(AVG(Rating) AS DECIMAL (10,1)) AS Avg_rating FROM blinkit_data

/*GRANULAR REQUIREMENTS*/
/*total sales by fat conent*/

SELECT Item_Fat_Content,
         CAST(SUM(Sales) AS DECIMAL(10,2)) AS TOTAL_SALES,
         CAST(AVG(Sales) AS DECIMAL(10,2)) AS AVG_SALES,
         COUNT(*) AS No_of_items,
         CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Fat_Content 
ORDER BY TOTAL_SALES DESC 


/*total sales by item type*/
SELECT TOP 5 Item_Type,
         CAST(SUM(Sales) AS DECIMAL(10,2)) AS TOTAL_SALES,
         CAST(AVG(Sales) AS DECIMAL(10,2)) AS AVG_SALES,
         COUNT(*) AS No_of_items,
         CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
WHERE Outlet_Establishment_Year = 2020
GROUP BY Item_Type 
ORDER BY TOTAL_SALES DESC

/*Fat content by outlet for total sales*/

SELECT Outlet_Location_Type,Item_Fat_Content,
         CAST(SUM(Sales) AS DECIMAL(10,2)) AS TOTAL_SALES,
         CAST(AVG(Sales) AS DECIMAL(10,2)) AS AVG_SALES,
         COUNT(*) AS No_of_items,
         CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Location_Type,Item_Fat_Content 
ORDER BY TOTAL_SALES DESC 

/* can use this type for precised value*/
SELECT 
    Outlet_Location_Type,
    ISNULL([Low Fat], 0) AS Low_Fat,
    ISNULL([Regular], 0) AS Regular
FROM
(
    SELECT 
        Outlet_Location_Type,
        Item_Fat_Content,
        Sales
    FROM 
        blinkit_data
) AS SourceTable 
PIVOT
(
    SUM(Sales)
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

/*TOTAL SALES BY OUTLET ESTABLISHMENT YEAR*/
SELECT Outlet_Establishment_Year,
         CAST(SUM(Sales) AS DECIMAL(10,2)) AS TOTAL_SALES
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC 

/* PERCENTAGE OF SALES BY OUTLET SIZE*/
SELECT Outlet_size, 
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(
        (SUM(Sales) * 100.0) / SUM(SUM(Sales)) OVER()
        AS DECIMAL(5,2)
    ) AS Sales_Percentage
FROM 
    blinkit_data
GROUP BY 
    Outlet_Size
ORDER BY 
    Sales_Percentage DESC;

/*SALES  BY OUTLET LOCATION*/
SELECT 
    Outlet_Location_Type,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
FROM 
    blinkit_data
GROUP BY 
    Outlet_Location_Type
ORDER BY 
    Total_Sales DESC;
/* ALL METRICS BY OUTLET TYPE*/

SELECT 
    Outlet_Type,
    COUNT(*) AS Total_Transactions,
    COUNT(DISTINCT Item_Identifier) AS Unique_Items,
    CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST(AVG(Sales) AS DECIMAL(10,2)) AS Avg_Sales_Per_Item,
    MAX(Sales) AS Max_Single_Sale,
    MIN(Sales) AS Min_Single_Sale,
    CAST(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER() AS DECIMAL(5,2)) AS Sales_Percentage
FROM 
    blinkit_data
GROUP BY 
    Outlet_Type
ORDER BY 
    Total_Sales DESC;














