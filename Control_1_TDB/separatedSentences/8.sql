SELECT comp.company_name, SUM(ds.total_amount_money) AS TotalRevenue FROM company AS comp
JOIN product AS prod ON comp.company_id = prod.company_id
JOIN detailed_selling_product AS dsp ON prod.product_id = dsp.product_id
JOIN detailed_selling AS ds ON dsp.detailed_selling_id = ds.detailed_selling_id
JOIN orders AS ord ON ds.detailed_selling_id = ord.detailed_selling_id
WHERE ord.order_date >= CURRENT_DATE - INTERVAL '1 YEAR'
GROUP BY comp.company_name
ORDER BY TotalRevenue DESC;
