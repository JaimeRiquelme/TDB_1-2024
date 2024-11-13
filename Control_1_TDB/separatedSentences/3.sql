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