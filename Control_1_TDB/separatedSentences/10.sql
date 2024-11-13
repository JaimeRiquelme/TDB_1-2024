-- Lista de clientes que han gastado más diariamente el mes pasado.
SELECT customer_id, total, customer_name, order_date
FROM (
    SELECT 
        cust.customer_id,
        SUM(det.total_amount_money) AS total,
        cust.customer_name, 
        ord.order_date,
        ROW_NUMBER() OVER(PARTITION BY cust.customer_id ORDER BY ord.order_date) AS row_num
    FROM orders AS ord
    JOIN customer AS cust ON cust.customer_id = ord.customer_id
    JOIN detailed_selling AS det ON det.detailed_selling_id = ord.detailed_selling_id
    WHERE ord.order_date >= CURRENT_DATE - INTERVAL '1 MONTH'
    GROUP BY cust.customer_id, ord.order_date, cust.customer_name) AS subquery
WHERE row_num = 1
ORDER BY total DESC;
