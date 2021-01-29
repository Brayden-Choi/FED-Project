--1.	Which outlet(s) in the East has a promotion of free delivery and belongs to the Japanese or Malay Cuisine. 

select o.*
	from Outlet o 
	INNER JOIN OutletCuisines oc
	on o.outletID = oc.outletID
	INNER JOIN Cuisine c
	on c.cuisineID = oc.cuisineID
	INNER JOIN Zone z 
	on z.zoneID = o.zoneID
	INNER JOIN OutletPromotions op
	on op.outletID = o.outletID
	INNER JOIN Promotion p
	on p.promoID = op.promoID

where (c.cuisineName = 'Japanese' OR c.cuisineName = 'Malay')
	AND z.zoneName = 'East' 
	AND p.isFreeDelivery = 'Y'
