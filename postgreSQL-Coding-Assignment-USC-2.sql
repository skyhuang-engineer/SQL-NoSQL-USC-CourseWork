-- DSO552 HW3 Xiangyu Huang
-- START Q1
SELECT country, COUNT(*)
FROM customers
WHERE region IS NULL or region NOT IN ('OR', 'TX')
GROUP BY country
ORDER BY 2 DESC
LIMIT 5;
-- END Q1
-- START Q2
SELECT c.categoryname, COUNT(*)
FROM products AS p
JOIN categories AS c ON c.categoryid = p.categoryid
GROUP BY c.categoryname
ORDER BY 2 DESC;
-- END Q2
-- START Q3
SELECT DISTINCT p.productid, p.productname
FROM products as p
JOIN order_details as o ON p.productid = o.productid
WHERE p.unitsinstock + p.unitsonorder < p.reorderlevel AND
	  p.discontinued = 0 AND
	  o.quantity > 1
	  ;
-- END Q3
-- START Q4
SELECT DATE_PART('year', o.shippeddate) ship_year, COUNT(*) total
FROM orders AS o
JOIN shippers AS s ON s.shipperid = o.shipvia
WHERE s.companyname IN ('Speedy Express', 'United Package') AND
	   o.shippeddate BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY DATE_PART('year', o.shippeddate);
-- END Q4
-- START Q5
SELECT o.shipcountry, AVG(o.freight) avg_freight
FROM orders o
JOIN shippers AS s ON s.shipperid = o.shipvia
WHERE s.companyname = 'Speedy Express' AND 
	 o.shippeddate BETWEEN '1996-01-01' AND '1996-12-31'
GROUP BY o.shipcountry
ORDER BY 2 DESC
LIMIT 3;
-- END Q5
-- START Q6
SELECT  lastname, firstname, COUNT(*) totallateorders
FROM employees AS e 
JOIN orders AS o ON o.employeeid = e.employeeid
WHERE requireddate <= shippeddate
GROUP BY  lastname, firstname
ORDER BY 3 DESC, 1;
-- END Q6
-- START Q7
SELECT c.companyname,  o.orderid, SUM(od.unitprice * od.quantity) totalorderamount
FROM customers AS c
JOIN orders AS o ON c.customerid = o.customerid
JOIN order_details AS od ON o.orderid = od.orderid
WHERE o.orderdate BETWEEN '1996-01-01' AND '1996-12-31'
GROUP BY c.companyname, o.orderid
HAVING SUM(od.unitprice * od.quantity) > 10000;
-- END Q7
-- START Q8
SELECT p.productname, p.unitprice, p.unitsinstock
FROM products AS p
GROUP BY p.productname, p.unitprice, p.unitsinstock 
HAVING p.unitprice > (SELECT AVG(unitprice)
						FROM products) 
						AND 
	 p.unitsinstock < (SELECT AVG(unitsinstock)
					  	FROM products);
-- END Q8
-- START Q9
SELECT (COUNT(*) + 0.001 - 0.001) / COUNT(DISTINCT o.employeeid) avg_orders_per_employee
FROM employees AS e
JOIN orders AS o ON o.employeeid = e.employeeid;
-- END Q9
-- START Q10
SELECT categoryname, 
	    AVG(od.discount*od.unitprice*od.quantity) avg_line_item_discount
FROM categories AS c
JOIN products AS p ON p.categoryid = c.categoryid
JOIN order_details AS od ON p.productid = od.productid
GROUP BY categoryname
HAVING AVG(od.discount*od.unitprice*od.quantity) > 
						(SELECT AVG(discount)*AVG(unitprice)*AVG(quantity)
						FROM order_details);
-- END Q10