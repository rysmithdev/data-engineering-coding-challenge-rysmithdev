/***************************************************************************************************
*   This script will create dimension and facts tables in the DATAWH schema of the RSMITH database
*   It uses tables found in the TEST_DATA schema of the SOURCES database
*
*   The following tables are created by this script:
*       DIM_CUSTOMER
*       DIM_ORDER
*       DIM_PRODUCT
*       FACT_ORDER_ITEMS
*
*   CHANGELOG:      2025-10-28      RJS         Initial creation
*
***************************************************************************************************/

CREATE SCHEMA IF NOT EXISTS RSMITH.DATAWH;

/***************************************************************************************************
* Drop and Create DIM_CUSTOMER table
***************************************************************************************************/

DROP TABLE IF EXISTS RSMITH.DATAWH.DIM_CUSTOMER;

CREATE TABLE RSMITH.DATAWH.DIM_CUSTOMER AS
SELECT DISTINCT
      CUSTOMER_ID                                       
    , FIRST_NAME as FIRST_NAME
    , LAST_NAME as LAST_NAME
    , LOWER(EMAIL) as EMAIL
    --RJS: Leaving this as all numerals for now, but can cast to other formats as necessary (e.g. XXX-XXXX)
    , REGEXP_REPLACE(PHONE, '[^0-9]', '') as PHONE
    --RJS: Handles a variety of date format conversions, more can be added as needed
    , COALESCE(
        TRY_TO_DATE(REGISTRATION_DATE, 'MON DD YYYY'),
        TRY_TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD'),
        TRY_TO_DATE(REGISTRATION_DATE, 'MM/DD/YYYY'),
        TRY_TO_DATE(REGISTRATION_DATE, 'YYYY/MM/DD')
      ) as REGISTRATION_DATE
    --RJS: Assigning Row Number to handle duplicates
    , STREET
    , CITY
    , STATE
    , ZIP
    , LOYALTY_STATUS
FROM
    SOURCES.TEST_DATA.CUSTOMERS;
    
/***************************************************************************************************
* Drop and Create DIM_ORDERS table
***************************************************************************************************/

DROP TABLE IF EXISTS RSMITH.DATAWH.DIM_ORDERS;

CREATE TABLE RSMITH.DATAWH.DIM_ORDERS AS
SELECT DISTINCT
      C1 as ORDER_ID                                   
    , C2 as CUSTOMER_ID
    --RJS: Handles a variety of date format conversions, more can be added as needed
    , COALESCE(
        TRY_TO_DATE(C3, 'MON DD YYYY'),
        TRY_TO_DATE(C3, 'YYYY-MM-DD'),
        TRY_TO_DATE(C3, 'MM/DD/YYYY'),
        TRY_TO_DATE(C3, 'YYYY/MM/DD'),
        TRY_TO_DATE(C3, 'MM-DD-YYYY')
      ) as ORDER_DATE
    --RJS: This will cast any non-numeric values to nulls, formatting the rest as XXXXXX.XX
    , TRY_CAST(C4 as NUMBER(8,2)) as ORDER_TOTAL
    , C5 as STATUS
    , C6 as PAYMENT_METHOD
FROM
    SOURCES.TEST_DATA.ORDERS
WHERE
    TRY_TO_NUMBER(C1) IS NOT NULL;    

/***************************************************************************************************
* Drop and Create DIM_PRODUCTS table
***************************************************************************************************/

DROP TABLE IF EXISTS RSMITH.DATAWH.DIM_PRODUCTS;

CREATE TABLE RSMITH.DATAWH.DIM_PRODUCTS AS
SELECT DISTINCT
      PRODUCT_ID
    , PRODUCT_NAME
    , CATEGORY
    --RJS: This will cast any non-numeric values to nulls, formatting the rest as XXXXXX.XX
    , TRY_CAST(PRICE as NUMBER(8,2)) as PRICE
    , SUPPLIER_ID
    , STOCK_QUANTITY
    --RJS: Handles a variety of date format conversions, more can be added as needed
    , COALESCE(
        TRY_TO_DATE(LAST_UPDATED, 'MON DD YYYY'),
        TRY_TO_DATE(LAST_UPDATED, 'YYYY-MM-DD'),
        TRY_TO_DATE(LAST_UPDATED, 'MM/DD/YYYY'),
        TRY_TO_DATE(LAST_UPDATED, 'YYYY/MM/DD'),
        TRY_TO_DATE(LAST_UPDATED, 'MM-DD-YYYY')
      ) as LAST_UPDATED       
FROM
    SOURCES.TEST_DATA.PRODUCTS;

/***************************************************************************************************
* Drop and Create FACT_ORDER_ITEMS table
***************************************************************************************************/

DROP TABLE IF EXISTS RSMITH.DATAWH.FACT_ORDER_ITEMS;

CREATE TABLE RSMITH.DATAWH.FACT_ORDER_ITEMS AS   
SELECT DISTINCT
      ORDER_ITEM_ID                                   
    , ORDER_ID
    , PRODUCT_ID
    , QUANTITY
    , UNIT_PRICE
    --RJS: If DISCOUNT_PERFECT is null, replace with 0s to avoid issues in downstream tables
    , COALESCE(DISCOUNT_PERCENT, 0) as DISCOUNT_PERCENT
FROM
    SOURCES.TEST_DATA.ORDER_ITEMS;



