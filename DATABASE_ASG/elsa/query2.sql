-- List all the riders that use a Motorcycle or an E-Scooter and delivered orders that were more than $5 and had a 10% promotions.
SELECT r.* FROM Rider r
INNER JOIN Delivery d
ON r.riderID = d.riderID
INNER JOIN OrderPromotions op
ON d.orderID = op.orderID
INNER JOIN payment pa
ON op.orderID = pa.orderID
INNER JOIN Promotion p
ON op.promoID = p.promoID
WHERE (r.deliveryMode = 'Motorcycle' 
OR r.deliveryMode = 'E-Scooter')
AND pa.pmtAmt > 5
AND p.percentDiscount = 10