/*
Show the order details with customer name, description of voucher used (if any) and delivery time of the orders 
which were delivered more than 1 hour after the order time and was by rider with Motocycle.
Sort the result in increasing order of order time.
*/

SELECT 
    co.orderID, c.custName, 
    COALESCE(v.voucherDescription, '-') 'voucherUsed', 
    d.deliveryAddress, co.orderDateTime, d.deliveryDateTime

FROM Delivery AS d
    JOIN CustOrder AS co
    ON co.orderID = d.orderID

    JOIN Rider AS r
    ON r.riderID = d.riderID

    LEFT JOIN Voucher AS v
    ON co.voucherID = v.voucherID

    LEFT JOIN Customer AS c
    ON co.custID = c.custID

WHERE 
    r.deliveryMode = 'Motorcycle' 
    AND 
    DATEDIFF(SECOND, orderDateTime, deliveryDateTime) > 3600

ORDER BY co.orderDateTime ASC
