<?php
require_once 'config/db.php';

$date = '2026-06-04';
$sql = "SELECT l.id, l.weight_kg, l.quantity_units, l.status, p.agreed_price, p.discount_amount, p.quantity_kg, p.received_units,
        CASE 
            WHEN l.unit_type = 'weight' THEN 
                (l.weight_kg * ((p.agreed_price - p.discount_amount) / NULLIF(p.quantity_kg, 0)))
            ELSE 
                (l.quantity_units * ((p.agreed_price - p.discount_amount) / NULLIF(p.received_units, 0)))
        END as waste_cost
        FROM leftovers l
        JOIN purchases p ON l.purchase_id = p.id
        WHERE l.decision_date = ? AND l.status IN ('Dropped', 'Auto_Dropped', 'Staff_Consumption')";

$stmt = $pdo->prepare($sql);
$stmt->execute([$date]);
$res = $stmt->fetchAll(PDO::FETCH_ASSOC);

print_r($res);
