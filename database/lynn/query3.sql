SELECT z.zoneName AS 'Zone', COUNT(d.orderID) AS 'Total number of deliveries'
FROM Delivery d
JOIN CustOrder co
ON co.orderID = d.orderID
INNER JOIN Outlet o
ON co.outletID = o.outletID
INNER JOIN Zone z 
ON o.zoneID = z.zoneID
WHERE YEAR(d.deliveryDateTime) = '2020'
GROUP BY z.zoneName

