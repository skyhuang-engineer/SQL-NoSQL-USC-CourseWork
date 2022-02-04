-- START Q4
SELECT SUM(num_lines) / COUNT(orderid)  AS average_line_items_per_order
FROM  (SELECT orderid, COUNT(*) num_lines
		FROM order_details
		GROUP BY orderid) line_table;
-- END Q4
-- START Q5
SELECT employeeid, COUNT(*)
FROM (SELECT o.employeeid, od.orderid,COUNT(discount)
FROM order_details AS od
JOIN orders AS o ON od.orderid = o.orderid
JOIN employees AS e ON o.employeeid = e.employeeid
WHERE od.discount >= (SELECT AVG(discount)
						FROM order_details)
GROUP BY o.employeeid,od.orderid) table_discount
GROUP BY 1
ORDER BY 2 DESC;
-- END Q5




