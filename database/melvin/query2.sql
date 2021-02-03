SELECT DISTINCT c.*, co.*
FROM Customer c INNER JOIN CustOrder co
ON c.CustID = co.custID
AND co.orderDateTime BETWEEN '2020-06-01' AND '2020-12-31'
INNER JOIN Outlet o
ON co.outletID = o.outletID
WHERE o.outletName = 'Mark''s Place'
ORDER BY co.orderDateTime ASC