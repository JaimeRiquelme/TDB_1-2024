SELECT
    DATE(o.order_date) AS order_date,
    COUNT(dsp.product_id) AS total_products
FROM
    Orders o
JOIN
    Detailed_Selling ds ON o.detailed_selling_id = ds.detailed_selling_id
JOIN
    Detailed_Selling_Product dsp ON ds.detailed_selling_id = dsp.detailed_selling_id
WHERE
    o.order_date >= (CURRENT_DATE - INTERVAL '1 MONTH')
GROUP BY
    DATE(o.order_date)
ORDER BY
    total_products DESC
LIMIT 1;