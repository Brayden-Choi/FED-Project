--1.	Which outlet(s) in the East has a promotion of free delivery and belongs to the Japanese Cuisine. 

select o.*
from Outlet o 
INNER JOIN OutletCuisines oc
on o.outletID = oc.outletID
INNER JOIN Zone z 
on z.zoneID = o.zoneID
INNER JOIN Cuisine c
on c.cuisineID = oc.cuisineID
INNER JOIN OutletPromotions op
on op.outletID = o.outletID
INNER JOIN Promotion p
on p.promoID = op.promoID
where c.cuisineID = 'Japanese' AND z.zoneName = 'East' AND p.isFreeDelivery = 'Y'
