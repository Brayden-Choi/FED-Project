SELECT o.outletID, o.outletName, o.address
FROM Outlet o INNER JOIN OutletPromotions op
ON o.outletID = op.outletID
AND o.openTime >= '09AM' AND o.closeTime <= '09PM'
INNER JOIN Promotion p
ON op.promoID = p.promoID
AND p.percentDiscount <= 10