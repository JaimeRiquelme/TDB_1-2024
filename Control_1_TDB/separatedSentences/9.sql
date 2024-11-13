-- Lista de repartidores que han llevado pedidos en moto o bicicleta a las comunas de Providencia y Santiago Centro.
SELECT deli.delivery_man_name, means.type_transportation, comm.name FROM delivery_man AS deli
JOIN means_of_transportation AS means ON means.delivery_man_id = deli.delivery_man_id 
JOIN delivery_man_communa AS deliComm ON deliComm.delivery_man_id = deli.delivery_man_id
JOIN communa AS comm ON comm.communa_id = deliComm.communa_id
WHERE (means.type_transportation = 'Motocicleta' OR means.type_transportation = 'Bicicleta') 
	AND (comm.name = 'Providencia' OR comm.name = 'Santiago Centro')
GROUP BY delivery_man_name, type_transportation, name;
