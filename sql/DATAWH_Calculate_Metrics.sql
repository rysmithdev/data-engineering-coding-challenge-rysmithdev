/***************************************************************************************************
*   This script creates metrics based on tables found in the DATAWH schema of the RSMITH database
*
*   It calculates the following:
*       Total Revenue by Month
*       Top 5 Customers by Revenue
*       Product Performance
*       Order Status Analysis
*
*   CHANGELOG:      2025-10-28      RJS         Initial creation
*
***************************************************************************************************/


/***************************************************************************************************
* Calculate Total Revenue by Month
* 
* This logic will group all orders by month of the order and calculate revenue using the following
* formula: Unit Price X Quanity Sold X (1 - Discount/100)
*
* It will only include orders placed in 2024 and will exclude cancelled orders and orders with
* unknown status
***************************************************************************************************/

SELECT 
    MONTH(ORD.ORDER_DATE) as REPORT_MONTH
    , CAST(
        SUM(FOI.UNIT_PRICE * FOI.QUANTITY * (1 - FOI.DISCOUNT_PERCENT / 100)) 
        AS NUMBER(8,2)
      ) as TOTAL_REVENUE

FROM 
    RSMITH.DATAWH.FACT_ORDER_ITEMS FOI
    INNER JOIN RSMITH.DATAWH.DIM_ORDERS ORD
        ON FOI.ORDER_ID = ORD.ORDER_ID
WHERE
    YEAR(ORD.ORDER_DATE) = 2024
    --RJS: Remove cancelled orders and orders with unknown status
    AND ORD.STATUS <> 'cancelled'
    AND ORD.STATUS IS NOT NULL
GROUP BY
    MONTH(ORD.ORDER_DATE)
ORDER BY 1;

/***************************************************************************************************
* Calculate Top 5 Customers by Revenue
*
* This logic will group all orders by customer and calculate revenue using the following
* formula: Unit Price X Quanity Sold X (1 - Discount/100)
*
* It will exclude cancelled orders and orders with unknown status
*
* After calculating revenue, the top 5 customers by total rvenue will be returned in order
***************************************************************************************************/

WITH CUS_REVENUE AS (
    SELECT 
          CUS.CUSTOMER_ID
        , CUS.FIRST_NAME
        , CUS.LAST_NAME
        , CAST(
            SUM(FOI.UNIT_PRICE * FOI.QUANTITY * (1 - FOI.DISCOUNT_PERCENT / 100)) 
            AS NUMBER(8,2)
          ) as TOTAL_REVENUE
        , ROW_NUMBER() OVER (
            ORDER BY SUM(FOI.UNIT_PRICE * FOI.QUANTITY * (1 - FOI.DISCOUNT_PERCENT / 100)) DESC
          ) AS REVENUE_RANK
    
    FROM 
        RSMITH.DATAWH.FACT_ORDER_ITEMS FOI
        INNER JOIN RSMITH.DATAWH.DIM_ORDERS ORD
            ON FOI.ORDER_ID = ORD.ORDER_ID
        INNER JOIN RSMITH.DATAWH.DIM_CUSTOMER CUS
            ON ORD.CUSTOMER_ID = CUS.CUSTOMER_ID
    WHERE
        --RJS: Remove cancelled orders and orders with unknown status
        ORD.STATUS <> 'cancelled'
        AND ORD.STATUS IS NOT NULL
    GROUP BY
          CUS.CUSTOMER_ID
        , CUS.FIRST_NAME
        , CUS.LAST_NAME
)
SELECT 
      REVENUE_RANK
    , CUSTOMER_ID
    , FIRST_NAME
    , LAST_NAME
    , TOTAL_REVENUE

FROM 
    CUS_REVENUE
WHERE
    REVENUE_RANK <= 5
ORDER BY 
    1;

/***************************************************************************************************
* Product Performance
*
* This logic will group all orders by product, calculating total units sold and calculating revenue 
* using the following formula: Unit Price X Quanity Sold X (1 - Discount/100)
*
* It will exclude cancelled orders and orders with unknown status
*
* The results will be return sorted by total revenue, from greatest to least
***************************************************************************************************/

SELECT 
      PROD.PRODUCT_ID
    , PROD.PRODUCT_NAME
    , SUM(FOI.QUANTITY) as TOTAL_UNITS_SOLD
    , CAST(
        SUM(FOI.UNIT_PRICE * FOI.QUANTITY * (1 - FOI.DISCOUNT_PERCENT / 100)) 
        AS NUMBER(8,2)
      ) as TOTAL_REVENUE

FROM 
    RSMITH.DATAWH.FACT_ORDER_ITEMS FOI
    INNER JOIN RSMITH.DATAWH.DIM_ORDERS ORD
        ON FOI.ORDER_ID = ORD.ORDER_ID
    INNER JOIN RSMITH.DATAWH.DIM_PRODUCTS PROD
        ON FOI.PRODUCT_ID = PROD.PRODUCT_ID
WHERE
    FOI.UNIT_PRICE IS NOT NULL
    --RJS: Remove cancelled orders and orders with unknown status
    AND ORD.STATUS <> 'cancelled'
    AND ORD.STATUS IS NOT NULL
GROUP BY
      PROD.PRODUCT_ID
    , PROD.PRODUCT_NAME
ORDER BY 
    4 DESC;

/***************************************************************************************************
* Order Status Analysis
*
* This logic will group all orders by order status, calculating total units sold and calculating 
* revenue using the following formula: Unit Price X Quanity Sold X (1 - Discount/100)
*
* It will exclude cancelled orders and orders with unknown status
*
* The results will be return sorted by total revenue, from greatest to least
***************************************************************************************************/

SELECT 
    ORD.STATUS
    , SUM(FOI.QUANTITY) as TOTAL_UNITS
    , CAST(
        SUM(FOI.UNIT_PRICE * FOI.QUANTITY * (1 - FOI.DISCOUNT_PERCENT / 100)) 
        AS NUMBER(8,2)
      ) as TOTAL_REVENUE

FROM 
    RSMITH.DATAWH.FACT_ORDER_ITEMS FOI
    INNER JOIN RSMITH.DATAWH.DIM_ORDERS ORD
        ON FOI.ORDER_ID = ORD.ORDER_ID
GROUP BY
    ORD.STATUS
ORDER BY 
    3 DESC;

