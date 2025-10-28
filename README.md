# Data Engineering Coding Challenge

Welcome to the Pri-Med Data Engineering coding challenge! This exercise is designed to assess your ability to work with real-world data quality issues, data modeling, SQL proficiency, and documentation skills.

**Estimated Time:** 1-2 hours

## Getting Started

### Step 1: Create Your Own Repository from This Template

1. Click the **"Use this template"** button at the top of this GitHub repository
2. Select **"Create a new repository"**
3. Set the repository name to: `data-engineering-coding-challenge-<your-username>`
   - Example: `data-engineering-coding-challenge-jdoe` (where `jdoe` is your username)
4. **Important:** Set the repository to **Public** so we can review your submission
5. Click **"Create repository"**

You now have your own copy of the challenge to work in!

### Step 2: Clone Your Repository

```bash
git clone https://github.com/<your-org>/data-engineering-coding-challenge-<your-username>.git
cd data-engineering-coding-challenge-<your-username>
```

Note: If you have issues creating a templated repo, you can download and send the finished work as a `.zip` to brose@pri-med.com

## Challenge Overview

You will be working with a simulated e-commerce dataset that contains common data quality issues you'd encounter in production environments. Your task is to clean, transform, and model this data in Snowflake, then answer business questions using SQL queries.

## Your Snowflake Environment

**Snowflake Account:** https://ewqtnsz-coding_challenge.snowflakecomputing.com

You have been provided with credentials to access a dedicated Snowflake account. Your environment includes:

- **READ-ONLY Access:** `SOURCES.TEST_DATA` database and schema containing raw source data
- **FULL Access:** A personal database (e.g., `JDOE` if your name is Jane Doe) where you can create schemas, tables, views, etc.

### Connecting to Snowflake

Navigate to Snowflake and create a new worksheet or workspace: 
```https://ewqtnsz-coding_challenge.snowflakecomputing.com```

## The Dataset

The source data has been pre-loaded into your Snowflake account in the `SOURCES.TEST_DATA` schema. The data represents an e-commerce platform with the following tables:

### Source Tables in `SOURCES.TEST_DATA`:

You can access the source data with:

```sql
SELECT * FROM SOURCES.TEST_DATA.ORDERS;
SELECT * FROM SOURCES.TEST_DATA.CUSTOMERS;
SELECT * FROM SOURCES.TEST_DATA.PRODUCTS;
SELECT * FROM SOURCES.TEST_DATA.ORDER_ITEMS;
```

### Known Data Quality Issues

Your solution should handle these real-world data problems:

- **Missing Values:** NULL, empty strings, and blank fields
- **Duplicate Records:** Exact duplicates that need deduplication
- **Inconsistent Date Formats:** Multiple date formats across and within files
  - `2024-01-15`
  - `01/16/2024`
  - `Jan 20 2024`
  - `2024/01/18`
- **Inconsistent Formatting:**
  - Email addresses in different cases
  - Phone numbers in various formats
- **Data Type Issues:** Numbers stored as strings, NULLs represented as text

## Challenge Tasks

### Part 1: Data Exploration & Profiling

Start by exploring the source data to understand the quality issues:

1. Query the `SOURCES.TEST_DATA` tables to understand the data structure
2. Identify and document data quality issues (duplicates, nulls, format inconsistencies)
3. Create a brief data quality assessment summary

**Deliverable:** Documentation of issues found and your planned approach

### Part 2: Dimensional Modeling

Design and implement dimensional and/or fact model(s) **directly from the source data** in `SOURCES.TEST_DATA`.

**Build your models in your personal database, applying transformations as you create the tables:**

- **Handle duplicates** - Use DISTINCT, GROUP BY, or your own logic to handle duplicate records
- **Standardize dates** - Convert date fields to proper DATE type with consistent formatting
- **Clean formatting** - Standardize emails (lowercase), phone numbers, etc. in your CREATE statements
- **Handle NULLs** - Decide how to handle missing/empty values for your model
- **Proper data types** - Ensure numeric fields are correct types

**Suggested dimensional model:**
- Dimension tables (e.g., dim_customers, dim_products, dim_date)
- Fact table(s) (e.g., fact_orders with line-item grain)
- Use simple joins and aggregations - keep it straightforward!

**Deliverable:** SQL scripts creating dimensions and facts with transformations applied

### Part 3: (Optional/Bonus) Business Intelligence Queries

Write SQL queries to answer these business questions:

1. **Total Revenue by Month** - Show total revenue for each month in 2024
2. **Top 5 Customers by Revenue** - Which customers have spent the most?
3. **Product Performance** - List products with their total quantity sold and revenue, ordered by revenue
4. **Order Status Analysis** - Show count and total value of orders by status (completed, pending, cancelled, shipped)

**Deliverable:** SQL queries with results and brief explanations

## Submission Requirements

- Please document your work in a clear, organized manner in your GitHub repository under the `sql/..` directory. 
- Create a .sql file for each model that will live in your personal database.schema. 
- Have the tables created in snowflake under your personal database and appropriate schema(s)
- Feel free to include additional scripts as well (i.e. validation queries, reports, etc)

Note: If you are having issues with github, send a .zip of the repo and all included files to brose@pri-med.com

**Data Quality Report** (optional/bonus):
   - Summary of data quality issues found with specific counts
   - Counts of duplicates, nulls, format inconsistencies per table
   - How you resolved each issue

### Submitting Your Work

1. Commit and push all your work to your repository:
   ```bash
   git add .
   git commit -m "Complete data engineering coding challenge"
   git push origin main
   ```

2. Ensure your repository is **Public** so we can review it

3. Send us the link to your repository:
   - `https://github.com/<your-org>/data-engineering-coding-challenge-<your-username>`

4. Your work in Snowflake should remain in your personal database (e.g., `JDOE`) for our review

## Tips for Success

- Start by exploring the data - run some SELECT queries to see what you're working with
- Don't overthink it - handle data quality issues directly in your dimensional model CREATE statements
- Use simple SQL - DISTINCT, GROUP BY, COALESCE, etc. No need for complex window functions
- Document your assumptions in comments or SOLUTION.md
- Your dimensional model doesn't need to be perfect, but explain your choices
- Focus on demonstrating your thought process

## Questions?

If you have questions about the challenge requirements or run into technical issues with Snowflake access, please reach out to brose@pri-med.com

---

Good luck! We're excited to see your approach to solving real-world data engineering problems.