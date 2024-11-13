-- Producto menos pedidos por compañía.
SELECT 
    company_name, 
    product_name, 
    sales_count
FROM (
    SELECT 
        comp.company_name, 
        prod.product_name, 
        COUNT(prod.product_id) AS sales_count,
        ROW_NUMBER() OVER (PARTITION BY comp.company_name ORDER BY COUNT(prod.product_id)) AS row_num
    FROM 
        company AS comp
        JOIN product AS prod ON prod.company_id = comp.company_id
        JOIN detailed_selling_product AS dsp ON dsp.product_id = prod.product_id
        JOIN detailed_selling AS ds ON ds.detailed_selling_id = dsp.detailed_selling_id
    GROUP BY 
        comp.company_name, 
        prod.product_name
) AS ranked_products
WHERE 
    row_num = 1
ORDER BY 
    company_name;

