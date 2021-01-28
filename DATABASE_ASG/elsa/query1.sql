-- List all customers and their payment details that paid for an order with cash and used a voucher that expires in 2021. Sort the results in descending order of payment amount.
SELECT c.*, p.* FROM Customer c
INNER JOIN CustOrder o
ON c.custID = o.custID
INNER JOIN Voucher v
ON v.voucherID = o.voucherID
INNER JOIN Payment p
ON o.orderID = p.orderID
WHERE p.pmtMode = 'Credit Card' 
AND o.voucherID IS NOT NULL 
AND DATEPART(year, v.expiryDate) = 2021
AND p.pmtType = 'Order Payment'
ORDER BY p.pmtAmt DESC