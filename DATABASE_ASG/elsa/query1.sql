-- List all customers and orderIDs that paid for an order with cash and used a voucher that expires in 2021. Sort the results in descending order of payment amount.
SELECT c.custID, custName, custContact,
custEmail, o.orderID FROM Customer c
INNER JOIN CustOrder o
ON c.custID = o.custID
INNER JOIN Payment p
ON o.orderID = p.orderID
WHERE p.pmtMode = 'Credit Card' 
AND o.voucherID IS NOT NULL 
AND p.pmtType = 'Order Payment'
ORDER BY p.pmtAmt DESC