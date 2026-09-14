/* ===========================================
          OLIST E-COMMERCE DATA ANALYSIS
   =========================================== */

/* ===========================================
          1. PROJECT OVERVIEW & OBJECTIVE
   ===========================================
   Why are we doing this analysis?

   The purpose of this project is to analyze Olist's
   Brazilian e-commerce data to understand business 
   performance, customer purchasing behavior, product
   and seller performance, payment patterns, customer
   satisfaction and delivery performance.

   The analysis combines data from customers, orders,
   order items, products, sellers, payments, reviews,
   geolocation and product category translation tables.

   The analysis will be performed using SQL to identify
   meaningful business trends and relationships in the data.

   The final insights will be presented through an
   interactive Power BI dashboard to support business
   decision-making.
   =========================================== */

/* ===========================================
                PROBLEM STATEMENT
   ===========================================
   Olist is a Brazilian e-commerce marketplace that
   connects customers with sellers across different
   regions of Brazil.

   The objective of this project is to analyze Olist's
   e-commerce data to understand overall sales performance,
   customer purchasing behavior, product and seller
   performance, payment patterns, review ratings and
   order delivery performance.
   
   The data cleaning and preparation process was
   performed using Python and Pandas to improve data
   quality and prepare the datasets for analysis.

   The data analysis was performed using SQL as the
   primary query language, with SQLite Online used as
   the SQL analysis environment. SQLite Online provided
   a convenient environment for importing the cleaned
   datasets, running SQL queries across multiple tables
   and efficiently exploring the data without requiring
   additional database setup.

   The analysis will answer questions such as:

   1. What products and categories are purchased most?
   2. How much revenue is generated over time?
   3. Which products and categories perform best?
   4. Which sellers contribute most to sales?
   5. What payment methods do customers prefer?
   6. How satisfied are customers with their purchases?
   7. How efficiently are orders delivered?
   8. Which geographic regions generate the most activity?
   9. What business opportunities or problem areas
      can be identified from the data?

   The final findings will be used to create an
   interactive Power BI dashboard containing the
   most important business KPIs and insights.
   ==================================================== */

/* ===========================================
          2. FIRST ANALYSIS:
          UNDERSTANDING THE DATA
   ===========================================
   Purpose:
   Before performing business analysis, we first need
   to understand the tables available in the database
   and verify that the imported data is accessible.

   This helps us understand the structure of the dataset
   and identify which tables and columns will be required
   for subsequent analysis.
   =========================================== */

/* ===========================================
          2.1 CHECKING ORDERS DATA
   ===========================================
   Purpose:
   Check the orders table to confirm that the cleaned
   order data has been imported correctly and to
   understand the available columns.
   =========================================== */

SELECT *
FROM clean_orders
LIMIT 5; 

/* ===========================================
          2.2 CHECKING THE DATA
   ===========================================
   Purpose:
   Check different tables to understand the
   available customer information and identify
   the columns that can be used for customer-level
   analysis and relationships with orders.
   =========================================== */

SELECT *
FROM customers
LIMIT 5; 

SELECT * 
FROM order_items 
LIMIT 5;

SELECT * 
FROM orders
LIMIT 5;

SELECT * 
FROM order_reviews
LIMIT 5;

SELECT * 
FROM order_payments
LIMIT 5;

/* ===========================================
          3. CUSTOMER & PRODUCT ANALYSIS
   ===========================================
   Purpose:
   Analyze customer purchasing behavior and identify
   the product categories that generate the highest
   number of purchases.
   =========================================== */

/* ===========================================
          3.1 TOP PRODUCT CATEGORIES BY
              NUMBER OF PURCHASES
   ===========================================
   Business Question:
   Which product categories are purchased most
   frequently on Olist?
   =========================================== */

SELECT
    ct.product_category_1 AS product_category,
    COUNT(*) AS product_count
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN category_translation AS ct
    ON p.product_category = ct.product_category
WHERE o.order_status = 'delivered'
GROUP BY
    ct.product_category_1
ORDER BY
    product_count DESC
LIMIT 20; 

/* ==============================================
                      INSIGHT:
   Bed, Bath & Table recorded the highest number
   of purchased items among delivered orders,
   followed by Health & Beauty, Sports & Leisure,
   Furniture & Decor and Computer Accessories.

   These categories represent some of the strongest
   sources of purchase volume in the Olist marketplace.
   ================================================== */ 
   
/* ===========================================
         3.2 SALES BY PRODUCT CATEGORY
   ===========================================
   Business Question:
   Which product categories generate the highest
   sales from delivered orders?
   ============================================ */ 
      
SELECT
    ct.product_category_1 AS product_category,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN category_translation AS ct
    ON p.product_category = ct.product_category
WHERE o.order_status = 'delivered'
GROUP BY
    ct.product_category_1
ORDER BY
    total_sales DESC
LIMIT 20;  

/* ===========================================
                     INSIGHT:
   Health & Beauty generated the highest sales
   value among the product categories analyzed, 
   followed by Watches & Gifts, Bed, Bath & Table,
   Sports & Leisure and Computers & Accessories.

   The results show that categories generating high
   purchase volume are not necessarily identical
   to those generating the highest sales value.
   ============================================== */  
   
/* ===========================================
           3.3 AVERAGE ITEM PRICE BY
              PRODUCT CATEGORY
   ===========================================
   Business Question:
   Which product categories have the highest
   average item price among delivered orders?
   =========================================== */

SELECT
    ct.product_category_1 AS product_category,
    ROUND(AVG(oi.price), 2) AS average_item_price
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN category_translation AS ct
    ON p.product_category = ct.product_category
WHERE o.order_status = 'delivered'
GROUP BY
    ct.product_category_1
ORDER BY
    average_item_price DESC
LIMIT 20; 

/* ===========================================
          INSIGHT:
   The average selling price varies considerably
   across product categories.

   Among the categories analyzed, Computers 
   had the highest average item price
   at approximately R$1,098.92.

   This was followed by Small Appliances, Home Oven
   & Coffee at R$638.21, Home Appliances at R$468.63,
   Agro Industry & Commerce at R$342.55 and
   Musical Instruments at R$282.59.

   These differences indicate that Olist's product
   categories operate across different price ranges.

   However, average item price should not be used
   alone to determine category performance. It should
   be considered alongside purchase volume and total
   revenue to understand the actual contribution of
   each category.
   =========================================== */  
   
/* ===========================================
           3.4 REPEAT CUSTOMER ANALYSIS
   ===========================================
   Business Question:
   How many customers made more than one purchase?

   Purpose:
   Identify repeat customers and understand
   customer retention behavior.
   =========================================== */

SELECT
    COUNT(*) AS repeat_customers
FROM (
    SELECT
        c.customer_unique,
        COUNT(o.order_id) AS order_count
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique
    HAVING COUNT(o.order_id) > 1
) AS repeat_customer_list; 

/* ===========================================
          INSIGHT:
   A total of 2,796 unique customers made more
   than one delivered purchase on Olist.

   This indicates that a portion of Olist's customer
   base returned to the marketplace for additional
   purchases, showing evidence of repeat purchasing
   behavior.

   However, repeat customers represent only one part
   of customer behavior, so the result should be
   considered alongside the overall number of unique
   customers.
   =========================================== */ 
   
/* ===========================================
           3.5 TOTAL UNIQUE CUSTOMERS
   ===========================================
   Business Question:
   How many unique customers placed delivered
   orders on Olist?
   =========================================== */

SELECT
    COUNT(DISTINCT c.customer_unique) AS unique_customers
FROM customers AS c
JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered';
   
 /* ===========================================
          INSIGHT:
   A total of 93,176 unique customers placed
   at least one delivered order on Olist.

   This indicates a large customer base with
   successful delivered purchases and provides
   the overall customer base against which repeat
   customer behavior can be evaluated.

   When compared with the 2,796 repeat customers,
   it also shows that repeat purchasing represents
   only a small portion of the overall customer base.
   =========================================== */  
    
/* ===========================================
            3.6 REPEAT CUSTOMER RATE
   ===========================================
   Business Question:
   What percentage of unique customers made
   more than one delivered purchase?

   Purpose:
   Measure the proportion of customers who
   returned to Olist after their first purchase.
   =========================================== */

WITH customer_orders AS (
    SELECT
        c.customer_unique,
        COUNT(o.order_id) AS order_count
    FROM customers AS c
    JOIN orders AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_unique
),

customer_summary AS (
    SELECT
        COUNT(*) AS total_customers,
        SUM(
            CASE
                WHEN order_count > 1 THEN 1
                ELSE 0
            END
        ) AS repeat_customers
    FROM customer_orders
)

SELECT
    ROUND(
        repeat_customers * 100.0 / total_customers,
        2
    ) AS repeat_customer_percentage
FROM customer_summary;
    
/* ===========================================
          INSIGHT:
   Approximately 3% of Olist's unique customers
   made more than one delivered purchase.

   This indicates that the majority of customers
   placed only one delivered order, while repeat
   purchasing represented a relatively small share
   of the customer base.
   =========================================== */   
   
/* ===========================================
       OVERALL RECOMMENDATION - SECTION 3
   ===========================================
   Olist should focus on strengthening customer
   retention by encouraging existing customers
   to make repeat purchases through targeted
   offers, personalized product recommendations
   and timely customer engagement.

   The relatively low repeat customer rate indicates
   an opportunity to increase customer purchasing
   frequency and build stronger long-term customer
   relationships.
   =========================================== */ 
   
/* ===========================================
           4. SALES & REVENUE ANALYSIS
   =========================================== 
   Purpose:
   Analyze Olist's sales performance and revenue
   trends to understand how the marketplace's
   business activity changes over time.

   This section examines revenue growth, delivered
   order volume, average order value, seller
   performance and payment activity to identify
   the key factors contributing to Olist's sales
   performance.
   =========================================== */

/* =========================================== 
           4.1 MONTHLY SALES TREND
   =========================================== 
   Business Question:
   How does Olist's sales change over time?

   Purpose:
   Identify monthly sales trends and understand
   periods of higher and lower sales performance.
   ============================================== */

SELECT
    strftime('%Y-%m', o.order_purchase_t) AS month,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    strftime('%Y-%m', o.order_purchase_t)
ORDER BY
    month; 
    
/* ===========================================
                     INSIGHT:
   Monthly sales shows a clear overall growth
   pattern across the Olist analysis period,
   particularly from 2017 into 2018.

   However, sales does not increase consistently
   every month. There are fluctuations between
   individual months, with certain periods generating
   substantially higher revenue than others.

   The results indicate that Olist experienced
   significant growth in sales activity over time,
   while monthly performance varied throughout
   the period.
   =========================================== */  
   
/* ===========================================
       4.2 MONTHLY DELIVERED ORDER VOLUME 
   ===========================================
   Business Question:
   How does the number of delivered orders
   change over time?

   Purpose:
   Analyze monthly delivered order volume and
   compare it with the monthly sales trend
   to understand whether sales growth is
   accompanied by an increase in order volume.
   =========================================== */

SELECT
    strftime('%Y-%m', o.order_purchase_t) AS month,
    COUNT(DISTINCT o.order_id) AS delivered_orders
FROM orders AS o
WHERE o.order_status = 'delivered'
GROUP BY
    strftime('%Y-%m', o.order_purchase_t)
ORDER BY
    month; 
    
/* ===========================================
                   INSIGHT:
   The number of delivered orders increased
   substantially over the analysis period.

   Order volume was relatively low during the
   initial months of 2016 and increased significantly
   during 2017 and 2018.

   The increase in delivered order volume is
   accompanied by the overall increase in monthly
   sales observed in the previous analysis.

   This indicates that the growth in Olist's sales
   was supported by increasing order activity over
   time.
   ================================================== */    
   
/* =============================================
       4.3 AVERAGE SALES PER DELIVERED ORDER
   =============================================
   Business Question:
   How much revenue does Olist generate on average
   from each delivered order, and how does this
   change over time?

   Purpose:
   Determine whether revenue growth is driven mainly
   by an increase in the number of orders or by
   customers spending more per order.
   =========================================== */

WITH order_totals AS (
    SELECT
        o.order_id,
        strftime('%Y-%m', o.order_purchase_t) AS month,
        SUM(oi.price) AS order_value
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        o.order_id,
        strftime('%Y-%m', o.order_purchase_t)
)

SELECT
  month,
  ROUND(AVG(order_value), 2) AS average_sales_per_delivered_order
FROM order_totals
GROUP BY
  month
ORDER BY
  month; 
    
/* ===========================================
                   INSIGHT:
   The average sales per delivered order remained 
   relatively stable throughout most of the 
   analysis period, generally ranging between 
   approximately R$130 and R$150 per delivered order.

   This indicates that the significant increase
   in Olist's sales over time was not primarily
   driven by customers spending substantially more
   per order.

   Instead, when considered alongside the increase
   in average sales per delivered order, the results 
   suggest that revenue growth was mainly supported 
   by an increase in the number of orders.

   December 2016 recorded an unusually low average
   order sales per order of R$10.90 and appears to 
   be an outlier compared with the other months.
   =============================================== */    
   
/* ===========================================
           4.4 SELLER PERFORMANCE
   ===========================================
   Business Question:
   Which sellers generate the highest sales 
   value from delivered orders?

   Purpose:
   Identify the sellers contributing the most
   sales to Olist's marketplace and understand
   the distribution of sales across sellers.
   =========================================== */

SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS total_sales
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    oi.seller_id
ORDER BY
    total_sales DESC
LIMIT 20;  

/* ===========================================
                   INSIGHT:
   Seller sales value varies across the marketplace,
   seller with the highest sales value generating
   approximately R$226.99K from delivered orders.

   The sales gradually decreases across the
   ranked sellers, indicating differences in the
   sales contribution of individual sellers.

   This shows that seller performance is not evenly
   distributed, with some sellers generating more
   marketplace sales value than others.
   =========================================== */
   
/* ===========================================
           4.5 PAYMENT METHOD ANALYSIS
   ===========================================
   Business Question:
   Which payment methods do customers use
   most frequently for their purchases?

   Purpose:
   Understand customer payment preferences
   and identify the payment methods that are
   most commonly used across Olist orders.
   =========================================== */

SELECT
    payment_type,
    COUNT(*) AS payment_count
FROM order_payments
GROUP BY
    payment_type
ORDER BY
    payment_count DESC;  
    
 /* ===========================================
                     INSIGHT:
   Credit card was the most frequently recorded
   payment method in the Olist dataset, with
   76,795 payment records.

   Boleto was the second most frequently recorded
   method with 19,784 payments, followed by
   vouchers with 5,775 and debit cards with 1,529.

   The results show that credit card payments
   accounted for the largest share of recorded
   payment activity on the platform.
   =========================================== */   
   
/* ===========================================
            4.5.1 PAYMENT VALUE BY
                  PAYMENT METHOD
   ===========================================
   Business Question:
   Which payment methods account for the
   highest total payment value?

   Purpose:
   Compare payment methods based on the total
   monetary value of payments recorded on Olist.
   ============================================= */

SELECT
    payment_type,
    ROUND(SUM(payment_value), 2) AS total_payment_value
FROM order_payments
GROUP BY
    payment_type
ORDER BY
    total_payment_value DESC; 
    
/* ===========================================
                   INSIGHT:
   Credit card was both the most frequently
   recorded payment method and the payment method
   associated with the highest total payment value.

   Credit card payments accounted for approximately
   R$1.25 crore in total payment value, substantially
   higher than the other payment methods.

   The ranking of payment methods was consistent
   across both payment frequency and total payment
   value, indicating that the payment method most
   commonly used by customers also accounted for
   the largest share of recorded payment value.
   ================================================ */  
   
/* ===========================================
       OVERALL RECOMMENDATION — SECTION 4
   ===========================================
   Olist should focus on sustaining its sales
   growth by increasing order volume while
   maintaining a strong customer purchasing
   experience.

   Since sales growth was accompanied by a
   significant increase in delivered order volume
   while average sales per delivered order remained
   relatively stable, future growth efforts should
   focus on attracting more customers and increasing
   purchase frequency rather than relying only on
   increasing the value of individual orders.

   Olist should also continue supporting credit
   card payments, as credit cards represented both
   the highest payment frequency and the highest
   total payment value in the dataset.

   In addition, seller performance should be
   monitored to understand differences in sales
   contribution and identify opportunities to
   support high-performing sellers.
   =========================================== */ 
   
/* ===========================================
           5. CUSTOMER SATISFACTION
              & REVIEW ANALYSIS
   ===========================================
   Purpose:
   Analyze customer review scores to understand
   overall customer satisfaction and identify
   patterns in customer feedback.

   This section will examine review ratings and
   explore whether customer satisfaction varies
   across different product categories and
   delivery performance.

   The analysis will help identify areas where
   customers are satisfied as well as areas that
   may require improvement.
   =========================================== */ 
   
/* ===========================================
        5.1 AVERAGE CUSTOMER REVIEW SCORE
   ===========================================
   Business Question:
   What is the overall average review score
   given by customers on Olist?

   Purpose:
   Measure the overall level of customer
   satisfaction on the Olist marketplace using
   customer review scores.
   =========================================== */ 
   
SELECT
    ROUND(AVG(review_score), 2) AS average_review_score
FROM order_reviews;

/* ===========================================
                     INSIGHT:
   The overall average customer review score
   on Olist was 4.09 out of 5.

   This indicates that customers generally
   had a positive experience with their purchases,
   as the average rating was above 4 out of 5.
   =========================================== */
   
/* ===========================================
           5.2 REVIEW SCORE DISTRIBUTION
   ===========================================
   Business Question:
   How are customer reviews distributed across
   different review scores?

   Purpose:
   Understand the distribution of customer
   satisfaction by examining how many reviews
   received each rating from 1 to 5.
   =========================================== */

SELECT
    review_score,
    COUNT(*) AS review_count
FROM order_reviews
GROUP BY
    review_score
ORDER BY
    review_score; 
    
/* ===========================================
                    INSIGHT:
   The majority of customer reviews received
   the highest rating of 5, with 57,328 reviews.

   Four-star reviews were the second-largest group
   with 19,142 reviews, while 3-star reviews
   accounted for 8,179 reviews.

   There were also 11,424 one-star reviews and
   3,151 two-star reviews, representing a
   significant number of low-rated customer
   experiences.

   Overall, the review distribution indicates
   generally positive customer satisfaction, while
   the volume of low-rated reviews highlights that
   there are still areas of the customer experience
   that may require improvement.
   ================================================= */
   
/* ===========================================
            5.3 AVERAGE REVIEW SCORE
                BY PRODUCT CATEGORY
   ===========================================
   BUSINESS QUESTION:
   Which product categories have the highest
   average customer review scores?

   PURPOSE:
   To compare customer satisfaction across
   product categories using customer review scores.
   Only delivered orders containing products
   from a single product category are included
   so that each order's review can be linked
   to one category.
   =========================================== */ 
   
WITH order_category AS (
    SELECT
        o.order_id,
        ct.product_category_1 AS product_category
    FROM orders AS o
    JOIN order_items AS oi
        ON o.order_id = oi.order_id
    JOIN products AS p
        ON oi.product_id = p.product_id
    JOIN category_translation AS ct
        ON p.product_category = ct.product_category
    WHERE o.order_status = 'delivered'
    GROUP BY
        o.order_id
    HAVING COUNT(DISTINCT ct.product_category_1) = 1
),

order_review_scores AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY
        order_id
)

SELECT
    oc.product_category,
    ROUND(AVG(ors.review_score), 2) AS average_review_score
FROM order_category AS oc
JOIN order_review_scores AS ors
    ON oc.order_id = ors.order_id
GROUP BY
    oc.product_category
ORDER BY
    average_review_score DESC;
    
/* ===========================================
                  INSIGHT:
   Customer satisfaction varies across
   product categories.

   Among the categories analyzed, CDs, DVDs &
   Musicals recorded the highest average review
   score at 4.64, followed by Fashion Children's
   Clothes at 4.50, Books General Interest at
   4.45, Construction Tools Tools at 4.44
   and Flowers at 4.42.

   On the lower end, Security & Services recorded
   the lowest average review score at 2.50,
   followed by Diapers & Hygiene at 3.26,
   Office Furniture at 3.49, Home Comfort 2
   at 3.63 and Fashion Male Clothing at 3.64.

   These results show that customer satisfaction
   differs considerably across product categories.
   Categories with lower average review scores
   may require further investigation to understand
   the factors contributing to customer
   dissatisfaction.

   The analysis is based on delivered orders
   containing products from a single product
   category, allowing the order-level review
   score to be associated with one category.
   =========================================== */    
   
/* ===========================================
              5.4 REVIEW SCORE BY
              DELIVERY PERFORMANCE
   ===========================================
   Business Question:
   How does delivery performance relate to
   customer review scores?

   Purpose:
   Analyze whether customers who experienced
   delayed deliveries gave lower review scores
   compared with customers whose orders were
   delivered on time.
   =========================================== */  
   
SELECT
    CASE
        WHEN DATE(order_delivered_6) <= DATE(order_estimated)
        THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(DISTINCT o.order_id) AS order_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders AS o
JOIN order_reviews AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND order_delivered_6 IS NOT NULL
  AND order_estimated IS NOT NULL
GROUP BY
    delivery_status
ORDER BY
    delivery_status;
    
/* ===============================================
                  INSIGHT:
   Delivery performance shows a strong association
   with customer review scores.

   Orders delivered on time received an average
   review score of 4.29, compared with 2.27 for
   orders that were delayed.

   Although delayed orders represented a smaller
   portion of the delivered orders, their substantially
   lower average review score indicates that delayed
   deliveries were strongly associated with lower
   customer satisfaction.

   This suggests that improving delivery reliability
   could help improve the overall customer experience.
   ================================================== */   
   
/* ===========================================
         5.5. AVERAGE REVIEW SCORE FOR
                 DELAYED ORDERS
   ===========================================
   BUSINESS QUESTION:
   What is the average customer review score
   for delayed orders?

   PURPOSE:
   To understand customer satisfaction among
   orders that were delivered after the
   estimated delivery date.
   =========================================== */

SELECT
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders AS o
JOIN order_reviews AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_6 IS NOT NULL
  AND o.order_estimated IS NOT NULL
  AND DATE(o.order_delivered_6) > DATE(o.order_estimated); 
    
/* ===========================================
                   INSIGHT:
   Delayed orders received an average customer
   review score of 2.27 out of 5.

   This indicates that customer satisfaction
   was relatively low among orders delivered
   after the estimated delivery date.

   The result suggests a strong association
   between delivery delays and lower customer
   satisfaction.

   Improving delivery reliability and reducing
   delayed orders could therefore help improve
   the overall customer experience.

   However, delivery delays are not the only
   factor that can affect customer satisfaction,
   so other factors should also be considered.
   ============================================ */    
   
/* ===========================================
           5.6 REVIEW SCORE BY MONTH
   ===========================================
   Business Question:
   How did the average customer review score
   change over time?

   Purpose:
   Track monthly average review scores to identify
   periods of improving or declining customer
   satisfaction.
   =========================================== */

SELECT
    strftime('%Y-%m', o.order_purchase_t) AS month,
    ROUND(AVG(r.review_score), 2) AS average_review_score
FROM orders AS o
JOIN order_reviews AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    strftime('%Y-%m', o.order_purchase_t)
ORDER BY
    month; 
    
/* ===========================================
                    INSIGHT:
   Customer review scores varied considerably
   during the early months of the analysis period,
   particularly in 2016.

   Throughout most of 2017, monthly average review
   scores remained above 4.00, indicating generally
   positive customer satisfaction.

   Review scores also remained relatively strong
   during 2018, although some monthly fluctuations
   were observed. March 2018 recorded a lower
   average review score of approximately 3.81,
   compared with higher scores in several other
   months.

   Overall, customer satisfaction remained
   generally positive throughout most of 2017
   and 2018, although monthly variations were
   present.

   The unusually high or low scores observed in
   some early months should be interpreted with
   caution because those periods may contain
   fewer reviews.
   =========================================== */  
   
/* ===========================================
       OVERALL RECOMMENDATION — SECTION 5
   ===========================================
   Olist should focus on maintaining its generally
   positive customer satisfaction while addressing
   the areas associated with lower review scores.

   The analysis shows that customer satisfaction
   can vary across different situations, with
   delayed orders being strongly associated with
   lower average review scores. Olist should
   therefore prioritize improving delivery
   reliability and reducing delivery delays.

   Low-performing product categories should also
   be investigated further to understand the
   factors contributing to lower customer
   satisfaction, such as product quality,
   delivery experience or other customer-related
   issues.

   Olist should regularly monitor review scores
   over time and across relevant business areas
   to identify emerging problems and measure
   improvements in customer satisfaction.

   By addressing delivery issues and investigating
   the causes of lower review scores, Olist can
   strengthen the overall customer experience
   while maintaining its generally positive
   satisfaction levels.
   =============================================== */   
   
/* ===========================================
         6. DELIVERY PERFORMANCE ANALYSIS
   ===========================================
   Purpose:
   Analyze Olist's delivery performance to understand
   how efficiently orders are delivered to customers.

   This section will examine delivery delays,
   on-time delivery performance, delivery time
   and changes in delivery performance over time.

   The analysis will help identify potential
   operational issues that may affect customer
   satisfaction.
   ============================================= */
   
/* ===========================================
          6.1 ON-TIME VS DELAYED ORDERS
   ===========================================
   Business Question:
   What is the number of delivered orders that
   were delivered on time versus delayed?

   Purpose:
   Measure Olist's overall delivery performance
   by comparing on-time and delayed orders.
   =========================================== */

SELECT
    CASE
        WHEN DATE(order_delivered_6) <= DATE(order_estimated)
        THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status,
    COUNT(order_id) AS order_count
FROM orders
WHERE order_status = 'delivered'
  AND NULLIF(TRIM(order_delivered_6), '') IS NOT NULL
  AND NULLIF(TRIM(order_estimated), '') IS NOT NULL
GROUP BY
    delivery_status; 
    
/* ===========================================
                    INSIGHT:
   Out of the delivered orders with available
   delivery and estimated delivery dates,
   89,750 orders were delivered on time, while
   6,532 orders were delivered after the estimated
   delivery date.

   This shows that the majority of delivered orders
   reached customers on or before the estimated
   delivery date, although a noticeable number of
   orders still experienced delivery delays.

   Overall, the results indicate that Olist achieved
   a high level of on-time delivery performance,
   while there remains an opportunity to further
   reduce delayed orders and improve delivery
   reliability.
   =============================================== */  
   
/* ===========================================
       6.2 DELIVERY PERFORMANCE PERCENTAGE
   ===========================================
   BUSINESS QUESTION:
   What percentage of delivered orders were
   delivered on time versus after the estimated
   delivery date?

   PURPOSE:
   To measure Olist's overall delivery performance
   by calculating the percentage of delivered orders
   that were on time or delayed.
   =========================================== */

WITH delivery_status AS (
    SELECT
        CASE
            WHEN DATE(order_delivered_6) <= DATE(order_estimated)
            THEN 'On Time'
            ELSE 'Delayed'
        END AS delivery_status
    FROM orders
    WHERE order_status = 'delivered'
      AND NULLIF(TRIM(order_delivered_6), '') IS NOT NULL
      AND NULLIF(TRIM(order_estimated), '') IS NOT NULL
)

SELECT
    delivery_status,
    COUNT(*) AS order_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM delivery_status),
        2
    ) AS percentage_of_orders
FROM delivery_status
GROUP BY delivery_status
ORDER BY delivery_status;  
   
/* ===========================================
                   INSIGHT:
   Approximately 93.22% of delivered orders
   reached customers on time, while 6.78%
   were delivered after the estimated delivery
   date.

   Although the majority of orders were delivered
   on time, 6,532 orders still experienced
   delivery delays.

   This indicates that Olist's overall delivery
   performance was strong, while reducing the
   remaining delayed orders could further improve
   delivery reliability and the customer experience.
   ================================================= */ 
   
/* ===========================================
            6.3 AVERAGE DELIVERY TIME
   ===========================================
   Business Question:
   How many days does it take, on average,
   for an order to reach the customer?

   Purpose:
   Measure the average delivery time of
   delivered orders.
   =========================================== */

SELECT
    ROUND(
        AVG(
            julianday(order_delivered_6)
            - julianday(order_purchase_t)
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND NULLIF(TRIM(order_delivered_6),'') IS NOT NULL; 
  
/* ===========================================
                     INSIGHT:
   The average delivery time for delivered orders
   was approximately 12.57 days from purchase
   to customer delivery.

   This indicates that customers waited nearly
   two weeks on average to receive their orders.

   Since delivery performance was also strongly
   associated with customer review scores, reducing
   delivery times and improving delivery reliability
   could help create a better customer experience.
   =============================================== */  
   
/* ===========================================
          6.4 AVERAGE DELIVERY TIME
                    BY MONTH
   ===========================================
   Business Question:
   How did the average delivery time change
   over time?

   Purpose:
   Track monthly average delivery time to identify
   improvements or increases in delivery speed.
   =========================================== */

SELECT
    strftime('%Y-%m', order_purchase_t) AS month,
    ROUND(
        AVG(
            julianday(order_delivered_6)
            - julianday(order_purchase_t)
        ),
        2
    ) AS average_delivery_days
FROM orders
WHERE order_status = 'delivered'
  AND NULLIF(TRIM(order_delivered_6),'') IS NOT NULL
GROUP BY
    strftime('%Y-%m', order_purchase_t)
ORDER BY
    month;   
    
/* ===========================================
                    INSIGHT:
   Average delivery time varied considerably
   across the analysis period rather than showing
   a consistent month-by-month pattern.

   Some of the largest variations occurred during
   the early months of the dataset. September 2016
   recorded an unusually high average delivery time
   of approximately 54.81 days, while December 2016
   recorded a much lower average of 4.69 days.

   During most of 2017, average delivery time
   generally remained between approximately
   11 and 15 days.

   During 2018, delivery time fluctuated but showed
   an improvement toward the later observed months,
   reaching approximately 7.74 days in August 2018.

   Overall, the results indicate that delivery time
   varied across different periods, with some months
   showing substantial improvements and others
   experiencing slower delivery.

   The unusually high or low averages in some early
   months should be interpreted with caution because
   those periods may contain fewer orders.
   ================================================== */  
   
/* ===========================================
           6.5 DELAYED ORDERS BY MONTH
   ===========================================
   Business Question:
   In which months did Olist experience a higher
   percentage of delayed deliveries?

   Purpose:
   Identify periods with relatively higher
   delivery delays and understand whether
   delivery performance varied over time.
   =========================================== */

SELECT
    strftime('%Y-%m', order_purchase_t) AS month,
    COUNT(order_id) AS total_orders,
    SUM(
        CASE
            WHEN DATE(order_delivered_6) > DATE(order_estimated)
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,
    ROUND(
        SUM(
            CASE
                WHEN DATE(order_delivered_6) > DATE(order_estimated)
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(order_id),
        2
    ) AS delayed_percentage
FROM orders
WHERE order_status = 'delivered'
  AND NULLIF(TRIM(order_delivered_6),'') IS NOT NULL
  AND NULLIF(TRIM(order_estimated),'') IS NOT NULL
GROUP BY
    strftime('%Y-%m', order_purchase_t)
ORDER BY
    month;   
    
/* ===========================================
                    INSIGHT:
   Delivery performance varied considerably
   across different months.

   Most months recorded relatively low
   delayed-order percentages, generally below
   7%. However, several periods experienced
   substantially higher delivery-delay rates.

   March 2018 recorded the highest delayed-order
   percentage at 18.96%, with 1,328 delayed
   orders. This was followed by February 2018
   at 14.13%, with 926 delayed orders, and
   November 2017 at 12.40%, with 904 delayed
   orders.

   These periods are particularly important
   because the higher delay percentages occurred
   alongside relatively high order volumes,
   resulting in a substantial number of delayed
   orders.

   In contrast, several months such as June 2018
   recorded much lower delay rates, with only
   1.16% of orders delayed.

   Overall, the results indicate that Olist's
   delivery performance was generally strong
   during most months, but certain periods
   experienced significant increases in delivery
   delays. These periods should be investigated
   to understand the operational factors
   contributing to the higher delay rates.
   ================================================= */   
   
/* ===========================================
           6.6 DELIVERY PERFORMANCE
              BY CUSTOMER STATE
   ===========================================
   Business Question:
   Does delivery performance vary across
   different customer states?

   Purpose:
   Identify customer states with relatively
   higher delivery delay rates.
   =========================================== */

SELECT
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    SUM(
        CASE
            WHEN DATE(o.order_delivered_6) > DATE(o.order_estimated)
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,
    ROUND(
        SUM(
            CASE
                WHEN DATE(o.order_delivered_6) > DATE(o.order_estimated)
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(o.order_id),
        2
    ) AS delayed_percentage
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
  AND NULLIF(TRIM(o.order_delivered_6),'') IS NOT NULL
  AND NULLIF(TRIM(o.order_estimated),'')  IS NOT NULL
GROUP BY
    c.customer_state
ORDER BY
    delayed_percentage DESC;   
    
/* ===========================================
                    INSIGHT:
   Delivery performance varied considerably
   across customer states, with noticeable
   differences in delayed-order rates.

   Several states recorded relatively high
   delayed-order percentages, including AL at
   21.41%, MA at 17.51%, SE at 15.27%, PI at
   13.95% and CE at 13.77%.

   However, these percentages should be
   interpreted alongside order volume, as
   smaller states can show high delay rates
   even when relatively few orders are affected.

   High-volume states had a greater operational
   impact because delays affected a much larger
   number of orders. RJ recorded 1,495 delayed
   orders out of 12,330 delivered orders, while
   SP recorded 1,819 delayed orders out of 40,428
   qualifying delivered orders.

   Despite their large order volumes, SP and MG
   maintained relatively low delay rates of
   4.50% and 4.58%, respectively. This suggests
   that some high-volume states were able to
   maintain relatively strong delivery performance.

   Overall, the findings indicate that Olist
   should evaluate delivery performance using
   both delayed-order percentage and delayed-order
   volume. Priority should be given to states where
   a high proportion of orders are delayed, as well
   as high-volume states where even a moderate
   delay rate can affect a large number of customers.
   =============================================== */    
   
/* ===========================================
      6.7 DELAYED ORDERS & CUSTOMER REVIEWS
                  BY STATE
   ===========================================
   BUSINESS QUESTION:
   How do customer review scores for delayed
   orders vary across customer states?

   PURPOSE:
   To examine whether customer satisfaction
   among delayed orders varies across different
   customer states.
   Review scores are first aggregated to the
   order level so that each order contributes
   equally to the state-level average.
   =========================================== */

WITH order_review_scores AS (
    SELECT
        order_id,
        AVG(review_score) AS review_score
    FROM order_reviews
    GROUP BY
        order_id
)

SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS delayed_orders,
    COUNT(DISTINCT ors.order_id) AS reviewed_delayed_orders,
    ROUND(AVG(ors.review_score), 2) AS average_review_score
FROM orders AS o
JOIN customers AS c
    ON o.customer_id = c.customer_id
JOIN order_review_scores AS ors
    ON o.order_id = ors.order_id
WHERE o.order_status = 'delivered'
  AND NULLIF(TRIM(o.order_delivered_6),'') IS NOT NULL
  AND NULLIF(TRIM(o.order_estimated),'') IS NOT NULL
  AND DATE(o.order_delivered_6) > DATE(o.order_estimated)
GROUP BY
    c.customer_state
ORDER BY
    average_review_score ASC;  
    
/* ===========================================
                   INSIGHT:
   Customer review scores for delayed orders
   were generally low across the customer states.

   Most states recorded average review scores
   below 3.00 among delayed orders, indicating
   that delayed deliveries were generally
   associated with lower customer satisfaction.

   Several high-volume states also recorded
   substantial numbers of delayed orders along
   with low average review scores. RJ recorded
   1,456 delayed orders with an average review
   score of 1.91, while SP recorded 1,785
   delayed orders with an average review score
   of 2.55. MG recorded 505 delayed orders with
   an average score of 2.36.

   The results also show that states with fewer
   delayed orders can have more variable review
   scores. For example, AC recorded an average
   score of 1.67 across 3 delayed orders, while
   some other low-volume states recorded higher
   average scores.

   Overall, the results indicate a strong
   association between delayed deliveries and
   lower customer satisfaction across many
   customer states. The effect is particularly
   important in high-volume states where a large
   number of delayed orders are affected.

   However, delivery delays are not the only
   factor that can influence customer review
   scores, so other factors should also be
   considered when evaluating customer
   satisfaction.
   =========================================== */    
   
/* ===========================================
       OVERALL RECOMMENDATION — SECTION 6
   ===========================================
   Olist should focus on improving delivery
   reliability and consistency across different
   periods and customer locations.

   Approximately 93.22% of qualifying delivered
   orders reached customers on or before the
   estimated delivery date, while 6.78% were
   delivered after the estimated date. Although
   overall delivery performance was strong,
   6,532 delayed orders still represent a
   significant number of affected orders.

   Delivery performance varied considerably
   across different months. March 2018 recorded
   the highest significant delayed-order rate
   at 18.96%, with 1,328 delayed orders, followed
   by February 2018 at 14.13% with 926 delayed
   orders and November 2017 at 12.40% with
   904 delayed orders.

   Delivery performance also varied across
   customer states. Olist should therefore
   evaluate both delayed-order percentage and
   delayed-order volume when identifying
   locations that require operational attention.

   The analysis also found a strong association
   between delivery performance and customer
   satisfaction. Orders delivered on time had
   an average review score of 4.29, compared
   with 2.27 for delayed orders.

   Olist should investigate the operational factors
   behind higher-delay periods and locations,
   including factors such as geographic location,
   distance, carrier performance and delivery times.
   Delivery estimates should be realistic and
   achievable while efforts continue to improve
   actual delivery performance.

   Improving delivery reliability and consistency
   could help reduce delayed orders and contribute
   to a better overall customer experience.
   =============================================== */ 
   
/* ===========================================
          OVERALL PROJECT RECOMMENDATION
   ===========================================
   he analysis indicates that Olist had strong
   marketplace activity and generally positive
   customer satisfaction, while the data also
   highlights opportunities to improve customer
   retention, delivery reliability and consistency
   across different business areas.

   1. CUSTOMER RETENTION

   Olist recorded 93,176 unique customers with
   delivered orders, while 2,796 customers made
   more than one delivered purchase, resulting
   in a repeat customer rate of approximately 3%.

   This indicates that the majority of customers
   placed only one delivered order.

   Olist should focus on increasing repeat purchases
   through targeted offers, personalized product
   recommendations and timely customer engagement.

   2. SALES GROWTH

   Monthly sales and delivered order volume
   increased substantially over the analysis period,
   while average sales per delivered order remained
   relatively stable at approximately R$130–R$150
   during most months.

   This suggests that the increase in sales was
   primarily supported by higher order activity
   rather than a substantial increase in the amount
   spent per delivered order.

   Olist should therefore continue focusing on
   increasing order activity and customer purchasing
   frequency while maintaining a strong purchasing
   experience.

   3. PRODUCT & CATEGORY PERFORMANCE

   Bed, Bath & Table recorded the highest purchase
   volume, while Health & Beauty recorded the
   highest sales value among the categories analyzed.

   Computers & Accessories recorded the highest
   average item price at approximately R$1,098.92.

   These results show that category performance
   differs depending on whether it is measured by
   purchase volume, total sales value or average
   selling price.

   Olist should therefore evaluate categories using
   multiple performance indicators rather than
   relying on a single metric.

   4. CUSTOMER SATISFACTION

   The overall average customer review score was
   4.09 out of 5, indicating generally positive
   customer satisfaction.

   However, review scores varied over time, with
   most monthly averages remaining above 4.00
   during 2017 and 2018, although some months
   recorded lower scores.

   Olist should regularly monitor customer review
   scores and investigate periods or business areas
   associated with lower satisfaction to identify
   opportunities for improvement.

   5. DELIVERY PERFORMANCE

   Approximately 93.22% of qualifying delivered
   orders reached customers on or before the
   estimated delivery date, while 6.78% were
   delivered after the estimated date.

   Although overall delivery performance was strong,
   6,532 qualifying delivered orders were delayed.

   Delivery performance also varied across different
   months and customer states. March 2018 recorded
   the highest significant delayed-order rate at
   18.96%, with 1,328 delayed orders.

   Olist should therefore monitor both delayed-order
   percentage and delayed-order volume when
   identifying periods and locations that require
   operational attention.

   6. DELIVERY & CUSTOMER SATISFACTION

   The analysis found a strong association between
   delivery performance and customer satisfaction.

   On-time orders associated with customer reviews
   received an average review score of 4.29,
   compared with 2.27 for delayed orders.

   This indicates that delayed deliveries were
   strongly associated with lower customer
   satisfaction.

   Olist should therefore prioritize improving
   delivery reliability and investigate the
   operational factors behind higher-delay periods
   and locations.

   However, delivery performance should not be
   considered the only factor affecting customer
   satisfaction, as other factors may also
   influence review scores.

   7. PAYMENT ACTIVITY

   Credit card was the most frequently recorded
   payment method, with 76,795 payment records
   and also accounted for the highest total
   payment value.

   Olist should continue supporting widely used
   payment methods while maintaining a convenient
   and reliable payment experience.

   OVERALL BUSINESS RECOMMENDATION

   Based on the analysis, Olist should focus on
   three major priorities: increasing repeat
   customer activity, maintaining sales growth
   through higher order activity and improving
   delivery reliability.

   The relatively low repeat customer rate of
   approximately 3% represents an opportunity
   to strengthen customer retention.

   At the same time, delivery delays should receive
   particular attention because of their strong
   association with lower customer review scores.

   Olist should use sales, customer, review and
   delivery metrics together to monitor marketplace
   performance and identify areas requiring
   further improvement.
   =========================================== */