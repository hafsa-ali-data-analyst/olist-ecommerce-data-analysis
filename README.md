# Olist E-Commerce Data Analysis

## Project Overview
Olist is a Brazilian e-commerce marketplace connecting customers with sellers across Brazil. This project analyzes Olist's marketplace data to understand sales performance, customer behavior, product and category performance, customer satisfaction, payment activity and delivery efficiency.

The project follows an end-to-end analytics workflow:

**Python & Pandas → Data Cleaning → SQL Analysis → Business Insights → Power BI Dashboard**

The goal was to transform raw transactional data into meaningful business insights and recommendations.

## Business Problem
Olist needs to understand how its marketplace is performing and identify areas that can improve customer retention, sales activity, customer satisfaction and delivery operations.

The analysis focuses on questions such as:
- How are sales and order activity changing over time?
- Which product categories perform best?
- How effectively are customers being retained?
- How satisfied are customers with their purchases?
- How reliable is the delivery process?
- Are delivery delays associated with lower customer satisfaction?
- Which business areas require attention?

## Tools & Technologies
- **Python:** Data cleaning and preparation using Pandas.
- **SQL:** Business analysis, aggregation, filtering and multi-table analysis.
- **SQLite Online:** Used as the SQL analysis environment because it allowed the cleaned CSV files to be imported and analyzed quickly without additional database setup.
- **Power BI:** Used to create the final interactive dashboard and communicate the most important findings.

## Data Cleaning & Preparation
The original Olist dataset contains multiple related CSV files covering customers, orders, order items, products, sellers, payments, reviews, geolocation and category translation.

Python and Pandas were used to:
- Inspect datasets and missing values.
- Identify and remove duplicate records where appropriate.
- Validate order delivery dates.
- Remove invalid order records.
- Remove product records with missing physical dimensions.
- Export cleaned datasets for analysis.

### Cleaning Results
| Dataset | Original Rows | Cleaned Rows |
|---|---:|---:|
| Customers | 99,441 | 99,441 |
| Geolocation | 1,000,163 | 720,494 |
| Order Items | 112,650 | 112,650 |
| Order Payments | 103,886 | 103,886 |
| Order Reviews | 99,224 | 99,224 |
| Orders | 99,441 | 99,252 |
| Products | 32,951 | 32,949 |
| Sellers | 3,095 | 3,095 |
| Category Translation | 71 | 71 |

## Dataset Selection
Not every cleaned dataset was required for the final Power BI model.
The **geolocation dataset was excluded from the final model** because it was not required for the selected dashboard insights and was significantly larger than the other datasets. Excluding it reduced model size without affecting the dashboard analysis.
The **seller dataset was retained in the cleaned project data** because seller-level analysis was explored during the SQL stage, although it was not required for the final dashboard.
Unused columns were also removed from the Power BI model where appropriate to reduce model size while preserving the data required for the dashboard.
This keeps the final model focused on the business questions rather than loading every available field.

## SQL Analysis
SQL was used to investigate the main business questions across the cleaned datasets.

### Customer & Product Analysis
The analysis examined:
- Purchase volume by product category.
- Sales value by category.
- Average item price by category.
- Unique customers.
- Repeat customers and repeat customer rate.

Key findings:
- **93,176 unique customers** had delivered orders.
- **2,796 customers** made more than one delivered purchase.
- Repeat customer rate was approximately **3%**.
- **Bed, Bath & Table** recorded the highest purchase volume.
- **Health & Beauty** recorded the highest sales value.
- **Computers & Accessories** had the highest average item price at approximately **R$1,098.92**.

### Sales Analysis
Sales performance was analyzed through monthly sales, delivered order volume, average sales per delivered order, seller sales value and category performance.
Monthly sales and delivered order activity increased substantially over the analysis period, while average sales per delivered order remained relatively stable during most months.

### Payment Activity
Payment activity was analyzed by payment method and total payment value.
**Credit card** was the most frequently recorded payment method, with **76,795 payment records** and also represented the highest total payment value.

## Customer Satisfaction
Customer reviews were analyzed to understand overall satisfaction and review patterns.
- **Average review score: 4.09 / 5**
- 5-star reviews represented the largest share of recorded reviews.
- Review scores were also analyzed over time to identify periods of stronger or weaker satisfaction.

## Delivery Performance
Delivery performance was evaluated by comparing actual delivery dates with estimated delivery dates.

Among qualifying delivered orders:
- **89,750** were delivered on time.
- **6,532** were delayed.
- **93.22%** were delivered on time.
- **6.78%** were delayed.
- Average delivery time was approximately **12.57 days**.

The highest significant monthly delay rates included:
- **November 2017: 12.40%**
- **February 2018: 14.13%**
- **March 2018: 18.96%**
March 2018 recorded **1,328 delayed orders**.

## Delivery & Customer Satisfaction
A strong association was identified between delivery performance and customer review scores.
- On-time orders: **4.29 / 5 average review**
- Delayed orders: **2.27 / 5 average review**
This indicates that delayed deliveries were strongly associated with lower customer satisfaction. However, delivery performance is not necessarily the only factor influencing review scores.

## Geographic Delivery Analysis
Delivery performance varied across customer states. States such as **AL, MA, SE, PI, and CE** recorded relatively high delay percentages, while high-volume states such as **SP and RJ** accounted for a larger number of delayed orders.
Therefore, both **delay percentage and absolute delay volume** should be considered when identifying operational priorities.

## Power BI Dashboard
The final Power BI dashboard focuses on the most important findings rather than reproducing every exploratory analysis.

### KPIs
| KPI | Value |
|---|---:|
| Total Sales | R$13.20M |
| Delivered Orders | 96K |
| Repeat Customer Rate | ~3% |
| Average Review Score | 4.09 / 5 |
| On-Time Delivery | 93.22% |

### Dashboard Visuals
- Monthly Sales Trend
- Top Categories by Sales
- Top Categories by Purchase Volume
- Review Score Distribution
- Monthly Delivery Delay Rate

### Filters
- Year
- Customer State

## Dashboard Preview
![Olist_Ecommerce_Marketplace_Insights_Dashboard](dashboard/Olist_Ecommerce_Marketplace_Insights_Dashboard.png)

The dashboard combines sales, customer, product, satisfaction and delivery metrics into a single business-focused view.

## Key Business Insights
**1. Customer Retention:** Approximately **3%** of unique customers made more than one delivered purchase, indicating a significant opportunity to improve repeat purchasing.
**2. Sales Growth:** Monthly sales and delivered order activity increased substantially, while average sales per delivered order remained relatively stable.
**3. Category Performance:** Category performance differed by metric. Bed, Bath & Table led purchase volume, Health & Beauty led sales value, and Computers & Accessories had the highest average item price.
**4. Customer Satisfaction:** The overall review score was **4.09 / 5**, indicating generally positive customer satisfaction.
**5. Delivery Performance:** Overall on-time delivery was strong at **93.22%**, but certain periods experienced significantly higher delay rates.
**6. Delivery & Reviews:** Delayed orders had an average review score of **2.27**, compared with **4.29** for on-time orders, highlighting delivery reliability as an important customer experience factor.

## Business Recommendations
### Improve Customer Retention
Use personalized recommendations, targeted promotions, and post-purchase engagement to encourage repeat purchases and improve the approximately **3% repeat customer rate**.

### Improve Delivery Reliability
Investigate the operational causes behind higher-delay periods and locations, with particular attention to significant spikes such as March 2018.

### Monitor Both Delay Rate & Volume
Evaluate delivery performance using both the percentage and number of delayed orders so that high-volume markets are not overlooked.

### Evaluate Categories Using Multiple Metrics
Use sales value, purchase volume, average selling price, and customer satisfaction together when evaluating product categories.

### Monitor Customer Satisfaction
Track review scores alongside operational metrics to identify periods and business areas requiring further investigation.

## Project Workflow
```text
Raw Olist CSV Files
        ↓
Python + Pandas
        ↓
Data Cleaning & Validation
        ↓
Cleaned CSV Files
        ↓
SQLite Online
        ↓
SQL Business Analysis
        ↓
Business Insights
        ↓
Power BI Dashboard
        ↓
Business Recommendations
