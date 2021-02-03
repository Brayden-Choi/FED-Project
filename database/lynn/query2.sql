SELECT DISTINCT mi.outletID AS 'Outlet', COUNT( DISTINCT co.custID) AS 'Unique Customers' FROM CustOrder co
INNER JOIN OrderItem oi
ON co.orderID = oi.orderID
INNER JOIN MenuItem mi
ON oi.itemID = mi.itemID
INNER JOIN Delivery d
ON co.orderID = d.orderID
WHERE YEAR(d.deliveryDateTime) = '2020' 
GROUP BY mi.outletID
