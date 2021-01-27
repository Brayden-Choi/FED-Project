-- List all the riders that use a Car or an E-Scooter and delivered orders that were more than $5 and had a 10% promotions.
SELECT r.riderID, r.riderNRIC, r.riderName, 
r.riderContact, r.riderDOB,
r.deliveryMode FROM Rider r
INNER JOIN Delivery d
ON r.riderID = d.riderID
INNER JOIN OrderPromotions op
ON d.orderID = op.orderID
INNER JOIN payment pa
ON op.orderID = pa.orderID
INNER JOIN Promotion p
ON op.promoID = p.promoID
WHERE (r.deliveryMode = 'Car' 
OR r.deliveryMode = 'E-Scooter')
AND pa.pmtAmt > 5
AND p.percentDiscount = 10