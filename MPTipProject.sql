--Concatenating tables into one

DROP TABLE IF EXISTS alltips
SELECT * INTO alltips
FROM tips1
UNION
SELECT *
FROM tips2
UNION
SELECT *
FROM tips3;

--Viewing data

SELECT *
FROM alltips;

--Finding tip percentage
--Total bill is including tax, so I have to combine the two columns for the tip percentage calculation to be accurate
--There is auto gratuity (18%) for parties of 8 or more, so I am going to combine the tip and gratuity columns for one single tip column

SELECT ROUND(Amount + Tax, 2) AS Amount, ROUND((Tip + Gratuity), 2) AS Tip, ROUND(((Tip+Gratuity)/(Amount + Tax))*100, 2) AS TipPct
FROM alltips
WHERE Amount > 1 AND Tip != 0;

--Averaging all tip percentages

SELECT ROUND(AVG((Tip+Gratuity)/(Amount + Tax))*100, 2) AS AvgTipPct
FROM alltips
WHERE Amount > 1 AND Tip != 0;

--Querying to find the total number of tables I have served

SELECT SUM(numserved.cnt) AS TotalServed
FROM (SELECT COUNT([Table]) AS cnt
		FROM alltips
		GROUP BY [Table]) as numserved;

--Also querying to find the total number of guests I have served

SELECT SUM(numguests.cnt) AS TotalGuests
FROM (SELECT Num_Guests*COUNT(Num_Guests) AS cnt
		FROM alltips
		GROUP BY Num_Guests) as numguests;

--Looking at how many times I have served a specific table, and the frequency as a % of the total
--I got 9.0 from 900 tables served, multiplying by 100 to find the percentage. (x/900)*100 == x/9

SELECT [Table], COUNT([Table]) AS NumServed, ROUND(COUNT(CAST([Table] AS int))/9.0, 2) AS Frequency
FROM alltips
GROUP BY [Table]
ORDER BY NumServed ASC;

--Looking at how many times I have served parties of varying sizes

SELECT Num_Guests, COUNT(Num_Guests) AS Cnt
FROM alltips
GROUP BY Num_Guests

--Total amount of tips I've made since Nov 2021
SELECT SUM(Tip + Gratuity) AS TotalTips
FROM alltips

--Curious to find the sum of money I've made from each table number and what % of my overall pay comes from each table
--I got 28554.88 as my total amount of tips. Dividing each table by 285.5488 will yield the percentage of each table's contribution

SELECT [Table], ROUND(SUM(Tip + Gratuity), 2) AS TotalPerTable, ROUND(SUM(Tip + Gratuity)/285.5488, 2) AS PctOfTotal
FROM alltips
WHERE Amount > 1
GROUP BY [Table]
ORDER BY TotalPerTable DESC;



