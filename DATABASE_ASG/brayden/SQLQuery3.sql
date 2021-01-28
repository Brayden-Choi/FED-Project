--2.	List all the rider(s) who has won at least 2 awards and has delivered at least 1 order in August 2020. Sort the result in descending order of orders delivered. \

select * 
from Rider r
INNER JOIN AwardsWon aw
on r.riderID = aw.riderID
