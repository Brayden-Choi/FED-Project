DECLARE @targetOutlet AS char(5) = 'O001'

SELECT mi.outletID, o.outletName, mi.menuNo, m.menuName, mi.itemID, itemName, itemDesc, itemPrice

FROM MenuItem AS mi
	JOIN Item AS i 
	ON i.itemID = mi.itemID
	
	JOIN Menu AS m
	ON m.outletID = mi.outletID AND m.menuNo = mi.menuNo

	JOIN Outlet AS o
	ON o.outletID = mi.outletID

WHERE mi.outletID = @targetOutlet