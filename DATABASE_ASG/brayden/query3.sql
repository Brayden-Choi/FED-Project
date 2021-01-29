--List the customers who ordered in the year 2020 who have ordered more than $20 worth of food. List the customer’s orders’ price in descending order. 

select cop.*, custName, custAddress, custContact, custEmail

FROM Customer c
INNER JOIN 
(
select custID, sum(p.pmtAmt) AS 'Total Price of Orders' from CustOrder co 
INNER JOIN Payment p
on co.orderID = p.orderID
where DATEPART(YEAR, orderDateTime) = 2020
group by co.custID
having sum(p.pmtAmt) > 20
)
AS cop
on c.custID = cop.custID

order by custID asc