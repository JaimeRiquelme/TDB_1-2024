-- Lista de clientes con más pedidos por compañía.
SELECT customer_name, company_name, individual_purchases as N°compras
FROM (
    SELECT company_purchases_table.customer_name, company_purchases_table.company_name, company_purchases_table.individual_purchases,
           ROW_NUMBER() OVER(PARTITION BY company_purchases_table.company_name ORDER BY company_purchases_table.individual_purchases DESC) as row_num
    FROM (
        SELECT company_purchases.customer_id, company_purchases.customer_name, company_purchases.company_name, COUNT(DISTINCT company_purchases.detailed_selling_id) as individual_purchases
        FROM (
            SELECT DISTINCT d.detailed_selling_id, b.company_name, c.customer_id, c.customer_name
            FROM customer c, detailed_selling d, detailed_selling_product dp, product p, company b
            WHERE c.customer_id = d.customer_id AND d.detailed_selling_id = dp.detailed_selling_id AND p.product_id = dp.product_id AND p.company_id = b.company_id
        ) as company_purchases
        GROUP BY company_purchases.customer_id, company_purchases.customer_name, company_purchases.company_name
    ) as company_purchases_table
) AS ranked
WHERE row_num = 1;
