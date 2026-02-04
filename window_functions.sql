--Purchase order per customer (ROW_NUMBER)--
SELECT 
    customer_id,
    purchase_date,
    amount,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY purchase_date) AS purchase_number
FROM purchases;
--Time gap between purchases (LAG)--
SELECT
    customer_id,
    purchase_date,
    amount,
    purchase_date - LAG(purchase_date) OVER (
        PARTITION BY customer_id ORDER BY purchase_date
    ) AS days_between_purchases
FROM purchases;
--Identify repeat customers--
SELECT DISTINCT customer_id
FROM (
    SELECT 
        customer_id,
        COUNT(*) OVER (PARTITION BY customer_id) AS total_purchases
    FROM purchases
) t
WHERE total_purchases > 1;
--Rank customers by total spend (RANK)--
SELECT
    customer_id,
    SUM(amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS spending_rank
FROM purchases
GROUP BY customer_id;
--First vs most recent purchase (FIRST_VALUE, LAST_VALUE)--
SELECT
    customer_id,
    FIRST_VALUE(purchase_date) OVER (
        PARTITION BY customer_id ORDER BY purchase_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS first_purchase,
    LAST_VALUE(purchase_date) OVER (
        PARTITION BY customer_id ORDER BY purchase_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS last_purchase
FROM purchases;
