QUERY 1: Total Customers vs Churned
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customer_churn;


QUERY 2: Churn Rate by Customer Type
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customer_churn
GROUP BY Contract
ORDER BY churn_rate_percent DESC;


QUERY 3: Top 10 High Value Customers Who Churned
SELECT 
    customerID,
    tenure,
    MonthlyCharges,
    TotalCharges,
    Contract
FROM customer_churn
WHERE Churn = 'Yes'
ORDER BY CAST(TotalCharges AS DECIMAL) DESC
NULLS LAST
LIMIT 10;


QUERY 4: Average Tenure of Churned vs Not Churned
SELECT 
    Churn,
    ROUND(AVG(tenure), 2) AS avg_tenure,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charges,
    COUNT(*) AS total_customers
FROM customer_churn
GROUP BY Churn;


QUERY 5: Churn by Internet Service Type
SELECT 
    InternetService,
    COUNT(*) AS total,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_percent
FROM customer_churn
GROUP BY InternetService
ORDER BY churn_rate_percent DESC;


QUERY 6: Window Function
SELECT 
    Contract,
    customerID,
    MonthlyCharges,
    RANK() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC) AS rank_within_contract
FROM customer_churn
WHERE Churn = 'Yes'
ORDER BY Contract, rank_within_contract
LIMIT 20;