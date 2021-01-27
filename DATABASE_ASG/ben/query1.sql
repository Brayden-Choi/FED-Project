/*
Display the riderID and number of Value Set bought of riders who have bought least 2 Value Sets and won at least 1 award. 
Sort the result in the decreasing number of Value set bought.
*/

SELECT r.riderID, SUM(purchaseQty) AS 'Number of Value Sets'

FROM EquipmentPurchase as ep
    JOIN Rider as r
    ON ep.riderID = r.riderID

WHERE
    equipID = (
	    SELECT equipID 
        FROM Equipment 
        WHERE equipName = 'Value Set'
    )
    AND
    r.riderID in (
        SELECT riderID 
        FROM AwardsWon 
        GROUP BY riderID 
        HAVING COUNT(awardID) >= 1
    )

GROUP BY r.riderID
HAVING SUM(purchaseQty) >= 2
ORDER BY 'Number of Value Sets' DESC