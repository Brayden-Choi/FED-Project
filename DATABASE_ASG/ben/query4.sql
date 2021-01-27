/*
Show customers details and number of Pickup and Delivery orders for customers that made more Pickup than Delivery orders. 
Sort the result in increasing number of Delivery orders.
*/


SELECT 
    c.custID, custName, custAddress, custContact, custEmail, 
    COALESCE(pickupCount, 0) 'No. of Pickup Orders', 
    COALESCE(deliveryCount, 0) 'No. of Delivery Orders'

FROM Customer AS c
    LEFT JOIN (
        SELECT custID, COUNT(orderID) AS pickupCount
        FROM CustOrder
        WHERE orderID IN (SELECT orderID FROM Pickup)
        GROUP BY custID
    ) AS pu
    ON pu.custID = c.custID

    LEFT JOIN (
        SELECT custID, COUNT(orderID) AS deliveryCount
        FROM CustOrder
        WHERE orderID IN (SELECT orderID FROM Delivery)
        GROUP BY custID
    ) AS de
    ON de.custID = c.custID

WHERE COALESCE(deliveryCount, 0) > COALESCE(pickupCount, 0)
ORDER BY deliveryCount ASC