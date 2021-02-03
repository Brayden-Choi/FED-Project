/*
List the food itemID and quantity sold from Ahmad Makan’s Dinner Menu that was sold at least 3 times.
*/

SELECT oi.itemID, SUM(oi.orderQty) 'Quantity Sold'

FROM OrderItem AS oi
    JOIN MenuItem AS mi
    ON oi.itemID = mi.itemID

    JOIN Menu as m
    ON m.outletID = mi.outletID AND m.menuNo = mi.menuNo

    JOIN Outlet as o
    ON o.outletID = mi.outletID AND m.menuNo = mi.menuNo

WHERE (o.outletName = 'Ahmad Makan' AND m.menuName = 'Dinner')

GROUP BY oi.itemID
HAVING SUM(oi.orderQty) >= 3
