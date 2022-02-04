-- Homework 5, xhuang16, Xiangyu Huang

-- START Q1
SELECT customerid, COUNT(*)
FROM (SELECT e.customerid, NTILE(4) OVER (ORDER BY contractprice) AS quantile, contractprice
FROM engagements e
JOIN customers c ON e.customerid = c.customerid) t1
WHERE t1.quantile = 4
GROUP BY 1;
-- END Q1

-- START Q2
SELECT engagementnumber, entstagename, contractprice * 1.1 AS adjusted_contractprice
FROM (SELECT e.entertainerid, ROW_NUMBER() OVER (PARTITION BY e.entertainerid ORDER BY startdate) AS times_engagement, 
	  entstagename, 
	  engagementnumber,
	  contractprice
FROM agents a
JOIN engagements e ON a.agentid = e.agentid
JOIN entertainers ent ON e.entertainerid = ent.entertainerid) t1
WHERE times_engagement = 10
ORDER BY 1;
-- END Q2

-- START Q3
SELECT *, SUM(agency_revenue) OVER (ORDER BY startdate,engagementnumber) AS running_total
FROM 
(SELECT eng.engagementnumber, startdate , 
		CASE WHEN entertainerid in (SELECT entertainerid
										FROM entertainers e
										NATURAL JOIN engagements eng
										NATURAL JOIN agents a
										GROUP BY entertainerid
										HAVING COUNT(*) >= 10) 
		THEN contractprice * 0.08
		ELSE contractprice * 0.1  END AS agency_revenue
FROM entertainers e
NATURAL JOIN engagements eng
NATURAL JOIN agents a
ORDER BY startdate) t1;
-- END Q3

-- START Q4
SELECT CASE WHEN name IN (SELECT stylename FROM musical_styles) THEN 'musical_style'
		ELSE 'agent' END AS type,
		name, num_engagement
FROM
((SELECT stylename AS name, COUNT(*) AS num_engagement
FROM musical_styles
JOIN entertainer_styles USING (styleid)
JOIN engagements USING (entertainerid)
GROUP BY 1
ORDER BY 2 DESC,1
LIMIT 5)

UNION

(SELECT CONCAT(a.agtfirstname, ' ', a.agtlastname) AS name, COUNT(*) AS num_engagement
FROM agents a 
JOIN engagements USING (agentid)
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5)) t1
ORDER BY 1 DESC, 3 DESC;
-- END Q4

-- START Q5
SELECT 	CASE WHEN digit > 25 THEN 'landline'
		 ELSE 'mobile' END phone_types, COUNT(*) AS num_phone_numbers
FROM (SELECT LEFT(phone_number,2)::INTEGER AS digit
FROM ((SELECT RIGHT(custphonenumber,4) AS phone_number FROM customers)
		UNION 
	  (SELECT RIGHT(agtphonenumber,4) AS phone_number FROM agents)) t1) t2
GROUP BY 1;
-- END Q5

-- START Q6
SELECT t1.*, (high_performance_bonus + 1.0)*(salary + commission) AS final_compensation
FROM 
(SELECT agentid, salary, SUM(commissionrate * contractprice) AS commission,
		CASE WHEN agentid IN (SELECT agentid FROM agents 
							  JOIN engagements USING (agentid)
							  GROUP BY 1
							  HAVING COUNT(engagementnumber) > 15) THEN 0.1
		ELSE 0.0 END AS high_performance_bonus
FROM agents
JOIN engagements USING (agentid)
GROUP BY 1,2) t1;
-- END Q6