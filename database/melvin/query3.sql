SELECT DISTINCT r.*
FROM Rider r INNER JOIN AwardsWon a
ON r.riderID = a.riderID
INNER JOIN Delivery d
ON r.riderID = d.riderID
INNER JOIN CustOrder co
ON d.orderID = co.orderID
INNER JOIN Outlet o
ON co.outletID = o.outletID
WHERE o.outletName = 'Vietry Good' OR o.outletName = 'La Chancla'