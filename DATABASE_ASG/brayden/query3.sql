--List the customers who ordered from 01/08/2020 to 01/12/2020 who have ordered more than $20 worth of food. List the customer’s orders’ price in descending order. 

select cop.*, custName, custAddress, custContact, custEmail

FROM Customer c
INNER JOIN 
(
select custID, sum(p.pmtAmt) AS 'Total Price of Orders' from CustOrder co 
INNER JOIN Payment p
on co.orderID = p.orderID
where '2020-08-01' < orderDateTime AND orderDateTime < '2020-12-01'
group by co.custID
having sum(p.pmtAmt) > 20
)
AS cop
on c.custID = cop.custID

order by custID desc