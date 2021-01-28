SELECT COUNT(*) AS "Number of riders",   LEFT(YEAR(r.riderDOB),3) + '0' AS "Decade"
FROM Rider r 
INNER JOIN Delivery d
ON r.riderID = d.riderID
WHERE YEAR(d.deliveryDateTime) = '2020' AND r.deliveryMode ='Motorcycle'
GROUP BY LEFT(YEAR(r.riderDOB),3)
ORDER BY LEFT(YEAR(r.riderDOB),3) ASC