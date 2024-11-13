-- 1. Lista de clientes con más pedidos por compañía.
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

-- 2. Producto menos pedidos por compañía.
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

-- 3. Medios de transporte más usados para repartir los pedidos por comuna de un cliente.
SELECT DISTINCT ON (C.name) 
    C.name AS Comuna_Name,
    MT.type_transportation AS Transportation_Type,
    COUNT(MT.type_transportation) OVER(PARTITION BY C.name, MT.type_transportation) AS Usage_Count
FROM 
    Orders O
    JOIN Customer CU ON O.customer_id = CU.customer_id
    JOIN Address A ON CU.customer_address = A.address_id
    JOIN Communa C ON A.communa_id = C.communa_id
    JOIN Delivery_Man DM ON O.delivery_man_id = DM.delivery_man_id
    JOIN Means_of_Transportation MT ON DM.delivery_man_id = MT.delivery_man_id
GROUP BY C.name, MT.type_transportation, O.delivery_man_id
ORDER BY C.name, COUNT(MT.type_transportation) OVER(PARTITION BY C.name, MT.type_transportation) DESC;

-- 4. Lista de regiones con más pedidos por mes, en los últimos 3 años.
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

-- 5. Lista de clientes por compañía que más ha pagado mensualmente.
SELECT c.customer_name, p.product_name, SUM(ds.total_amount_money) AS total_amount_money
FROM Customer c
JOIN Detailed_Selling ds ON c.customer_id = ds.customer_id
JOIN Orders o ON ds.detailed_selling_id = o.detailed_selling_id
JOIN Detailed_Selling_Product dsp ON ds.detailed_selling_id = dsp.detailed_selling_id
JOIN Product p ON dsp.product_id = p.product_id
WHERE EXTRACT(MONTH FROM o.order_date) = EXTRACT(MONTH FROM CURRENT_DATE)
AND EXTRACT(YEAR FROM o.order_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY c.customer_name, p.product_name
ORDER BY total_amount_money DESC;

-- 6. Pedido diario con más productos del último mes.
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

-- 7. Lista de repartidores con la mayor cantidad de despachos mensuales, en los últimos 3 años.
WITH MonthlyDeliveries AS (
    SELECT
        d.delivery_man_id,
        d.delivery_man_name,
        DATE_PART('year', o.order_date) AS year,
        DATE_PART('month', o.order_date) AS month,
        COUNT(*) AS delivery_count
    FROM
        Orders o
    JOIN Delivery_Man d ON o.delivery_man_id = d.delivery_man_id
    WHERE
        o.order_date >= CURRENT_DATE - INTERVAL '3 years'
    GROUP BY
        d.delivery_man_id,
        d.delivery_man_name,
        year,
        month
),
RankedDeliveries AS (
    SELECT
        delivery_man_id,
        delivery_man_name,
        year,
        month,
        delivery_count,
        RANK() OVER (PARTITION BY year, month ORDER BY delivery_count DESC) AS rank
    FROM
        MonthlyDeliveries
)
SELECT
    delivery_man_id,
    delivery_man_name,
    year,
    month,
    delivery_count
FROM
    RankedDeliveries
WHERE
    rank = 1
ORDER BY
    year DESC,
    month DESC,
    delivery_man_name;

-- 8. Lista de compañías que han recibido más dinero en el último año.
SELECT comp.company_name, SUM(ds.total_amount_money) AS TotalRevenue FROM company AS comp
JOIN product AS prod ON comp.company_id = prod.company_id
JOIN detailed_selling_product AS dsp ON prod.product_id = dsp.product_id
JOIN detailed_selling AS ds ON dsp.detailed_selling_id = ds.detailed_selling_id
JOIN orders AS ord ON ds.detailed_selling_id = ord.detailed_selling_id
WHERE ord.order_date >= CURRENT_DATE - INTERVAL '1 YEAR'
GROUP BY comp.company_name
ORDER BY TotalRevenue DESC;

-- 9. Lista de repartidores que han llevado pedidos en moto o bicicleta a las comunas de Providencia y Santiago Centro.
SELECT deli.delivery_man_name, means.type_transportation, comm.name FROM delivery_man AS deli
JOIN means_of_transportation AS means ON means.delivery_man_id = deli.delivery_man_id 
JOIN delivery_man_communa AS deliComm ON deliComm.delivery_man_id = deli.delivery_man_id
JOIN communa AS comm ON comm.communa_id = deliComm.communa_id
WHERE (means.type_transportation = 'Motocicleta' OR means.type_transportation = 'Bicicleta') 
	AND (comm.name = 'Providencia' OR comm.name = 'Santiago Centro')
GROUP BY delivery_man_name, type_transportation, name;

-- 10. Lista de clientes que han gastado más diariamente el mes pasado.
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
