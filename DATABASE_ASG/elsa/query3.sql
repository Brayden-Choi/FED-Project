-- List all teamIDs and teamNames of teams that received an award and was led by a rider that has delivered at least 1 order from outlets that sell “Western” Food in December 2020.  
SELECT t.* FROM Team t

INNER JOIN Rider r
ON t.leaderID = r.riderID

INNER JOIN Delivery d
ON r.riderID = d.riderID

INNER JOIN CustOrder co
ON d.orderID = co.orderID

INNER JOIN OutletCuisines oc
ON co.outletID = oc.outletID

INNER JOIN Cuisine c
ON oc.cuisineID = c.cuisineID

WHERE t.awardID IS NOT NULL 
AND t.leaderID IS NOT NULL
AND DATEPART(year, d.deliveryDateTime) = 2020
AND c.cuisineName = 'Western'