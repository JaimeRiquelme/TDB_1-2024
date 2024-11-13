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
