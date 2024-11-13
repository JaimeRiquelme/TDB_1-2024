SELECT
    EXTRACT(YEAR FROM O.order_date) AS year,
    EXTRACT(MONTH FROM O.order_date) AS month,
    R.name AS region_name,
    COUNT(*) AS num_orders
FROM
    Orders O
    INNER JOIN Customer CU ON O.customer_id = CU.customer_id
    INNER JOIN Address A ON CU.customer_address = A.address_id
    INNER JOIN Communa CO ON A.communa_id = CO.communa_id
    INNER JOIN Region R ON CO.region_id = R.region_id
WHERE
    O.order_date >= CURRENT_DATE - INTERVAL '3 years'
GROUP BY
    year,
    month,
    R.name
ORDER BY
    year DESC,
    month DESC,
    num_orders DESC;