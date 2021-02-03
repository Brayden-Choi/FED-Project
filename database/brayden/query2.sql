--2.	List all the rider(s) who has won at least 2 awards and has delivered at least 1 order in 2020. Sort the result in descending order of orders delivered. \

select 
	rw.*, riderNRIC, riderName, riderContact,
	riderAddress, riderDOB, deliveryMode, teamID

from Rider r
INNER JOIN 
(
	select aw.riderID, COUNT(awardID) AS 'Number of awards won' from AwardsWon aw
	INNER JOIN Rider r
	on r.riderID = aw.riderID
	group by aw.riderID
	having COUNT(awardID) > 1
)
AS rw
on r.riderID = rw.riderID

INNER JOIN
(
	select aw.riderID from AwardsWon aw
	INNER JOIN Delivery d
	on d.riderID = aw.riderID
	where DATEPART(YEAR,d.deliveryDateTime) = 2020
	group by aw.riderID
	having COUNT(orderID) > 0
)
AS aw
on r.riderID = aw.riderID

order by r.riderID asc