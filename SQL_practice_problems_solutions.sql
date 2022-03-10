USE northwind;

-- Ex. 1
SELECT *
FROM   shippers;

-- Ex. 2
SELECT categoryname,
       description
FROM   categories;

-- Ex. 3
SELECT firstname,
       lastname,
       hiredate
FROM   employees
WHERE  title = 'Sales Representative';

-- Ex. 4
SELECT firstname,
       lastname,
       hiredate
FROM   employees
WHERE  title = 'Sales Representative'
       AND country = 'USA';

-- Ex. 5
SELECT orderid,
       orderdate
FROM   orders
WHERE  employeeid = 5;

-- Ex. 6
SELECT supplierid,
       contactname,
       contacttitle
FROM   suppliers
WHERE  contacttitle != 'Marketing Manager';

-- Ex. 7
SELECT productid,
       productname
FROM   products
WHERE  productname LIKE '%queso%';

-- Ex. 8
SELECT orderid,
       customerid,
       shipcountry
FROM   orders
WHERE  shipcountry IN ( 'France', 'Belgium' );

-- Ex. 9
SELECT orderid,
       customerid,
       shipcountry
FROM   orders
WHERE  shipcountry IN ( 'Brazil', 'Mexico', 'Argentina', 'Venezuela' );

-- Ex. 10
SELECT firstname,
       lastname,
       title,
       birthdate
FROM   employees
ORDER  BY birthdate ASC;

-- Ex. 11
SELECT firstname,
       lastname,
       title,
       CONVERT(DATE, birthdate, 23)
FROM   employees
ORDER  BY birthdate ASC;

-- Ex. 12
SELECT firstname,
       lastname,
       ( firstname + ' ' + lastname ) AS FullName
FROM   employees

-- Ex. 13
SELECT orderid,
       productid,
       unitprice,
       quantity,
       ( unitprice * quantity ) AS TotalPrice
FROM   [order details]
ORDER  BY orderid,
          productid;

-- Ex. 14
SELECT Count(customerid) AS TotalCustomers
FROM   customers;

-- Ex. 15
SELECT Min(orderdate)
FROM   orders;

-- Ex. 16
SELECT country
FROM   customers
GROUP  BY country;

-- Ex. 17
SELECT contacttitle,
       Count(contacttitle) AS TotalContactTitle
FROM   customers
GROUP  BY contacttitle
ORDER  BY totalcontacttitle DESC;

-- Ex. 18
SELECT P.productid,
       P.productname,
       S.companyname
FROM   products AS P,
       suppliers AS S
WHERE  P.supplierid = S.supplierid
ORDER  BY P.productid;

-- Ex. 19
SELECT orderid,
       CONVERT(DATE, orderdate, 23) AS OrderDate,
       companyname
FROM   orders AS o
       JOIN shippers AS s
         ON o.shipvia = s.shipperid
            AND o.orderid < 10300
ORDER  BY orderid;

-- Intermediate Q
-- Ex. 20
SELECT categoryname,
       Count(productid) AS nb_products
FROM   dbo.products AS p
       LEFT JOIN dbo.categories AS c
              ON p.categoryid = c.categoryid
GROUP  BY categoryname
ORDER  BY nb_products DESC;

-- EX. 21
SELECT Count(customerid) AS Total,
       country,
       city
FROM   dbo.customers
GROUP  BY country,
          city
ORDER  BY total DESC;

-- EX. 22
SELECT productid,
       productname,
       unitsinstock,
       reorderlevel
FROM   dbo.products
WHERE  unitsinstock < reorderlevel
ORDER  BY productid;

-- EX. 23
SELECT productid,
       productname,
       unitsinstock,
       unitsonorder,
       reorderlevel,
       discontinued
FROM   dbo.products
WHERE  unitsinstock + unitsonorder <= reorderlevel
       AND discontinued = 0;

-- EX. 24
SELECT customerid,
       companyname,
       region
FROM   dbo.customers
ORDER  BY( CASE
             WHEN region IS NULL THEN 1
             ELSE 0
           END ),
         region,
         customerid;

-- EX. 25
SELECT TOP(3) shipcountry,
              Avg(freight) AS AvgFreight
FROM   dbo.orders
GROUP  BY shipcountry
ORDER  BY avgfreight DESC;

-- EX. 26
SELECT TOP(3) shipcountry,
              Avg(freight) AS AvgFreight
FROM   dbo.orders
WHERE  Year(orderdate) = 1997
GROUP  BY shipcountry
ORDER  BY avgfreight DESC;

-- EX. 27
SELECT *
FROM   orders
ORDER  BY orderdate

-- EX. 28
SELECT TOP(3) shipcountry,
              Avg(freight) AS AvgFreight
FROM   dbo.orders
WHERE  orderdate >= Dateadd(yy, -1, (SELECT Max(orderdate)
                                     FROM   dbo.orders))
GROUP  BY shipcountry
ORDER  BY avgfreight DESC;

-- EX. 29
SELECT e.employeeid,
       e.lastname,
       o.orderid,
       p.productname,
       od.quantity
FROM   employees AS e
       JOIN orders AS o
         ON e.employeeid = o.employeeid
       JOIN [order details] AS od
         ON o.orderid = od.orderid
       JOIN products AS p
         ON p.productid = od.productid
ORDER  BY o.orderid,
          p.productid;

-- EX. 30
SELECT customers.customerid,
       orders.customerid
FROM   customers
       LEFT JOIN orders
              ON orders.customerid = customers.customerid
WHERE  orders.orderid IS NULL;

-- EX. 31
SELECT customers.customerid,
       orders.customerid
FROM   customers
       LEFT JOIN orders
              ON orders.customerid = customers.customerid
                 AND orders.employeeid = 4
WHERE  orders.orderid IS NULL;

-- EX. 32
SELECT customers.customerid,
       customers.companyname,
       orders.orderid,
       TotalOrderAmount = Sum(quantity * unitprice)
FROM   customers
       JOIN orders
         ON orders.customerid = customers.customerid
       JOIN [order details]
         ON orders.orderid = [order details].orderid
WHERE  Year(orderdate) = 1998
GROUP  BY customers.customerid,
          customers.companyname,
          orders.orderid
HAVING Sum(quantity * unitprice) > 10000
ORDER  BY totalorderamount DESC;

-- Ex. 33
SELECT customers.customerid,
       customers.companyname,
       TotalOrderAmount = Sum(quantity * unitprice)
FROM   customers
       JOIN orders
         ON orders.customerid = customers.customerid
       JOIN [order details]
         ON orders.orderid = [order details].orderid
WHERE  Year(orderdate) = 1998
GROUP  BY customers.customerid,
          customers.companyname
HAVING Sum(quantity * unitprice) > 15000
ORDER  BY totalorderamount DESC;

-- Ex. 34
SELECT customers.customerid,
       customers.companyname,
       TotalOrderAmount = Sum(quantity * unitprice * ( 1 - discount ))
FROM   customers
       JOIN orders
         ON orders.customerid = customers.customerid
       JOIN [order details]
         ON orders.orderid = [order details].orderid
WHERE  Year(orderdate) = 1998
GROUP  BY customers.customerid,
          customers.companyname
HAVING Sum(quantity * unitprice * ( 1 - discount )) > 10000
ORDER  BY totalorderamount DESC;

-- Ex. 35

SELECT employeeid,
       orderid,
       orderdate
FROM   orders
WHERE  orderdate = Eomonth(orderdate)
ORDER  BY employeeid,
          orderid;

-- Ex. 36

SELECT TOP 10 orders.orderid,
              totalorderdetails = Count(*)
FROM   orders
       JOIN [order details]
         ON orders.orderid = [order details].orderid
GROUP  BY orders.orderid
ORDER  BY Count(*) DESC;

-- Ex. 37

SELECT TOP 2 PERCENT orderid
FROM   orders
ORDER  BY Newid(); -- NewId() function creates a globally unique identifier (GUID)

-- Ex. 38

SELECT orderid
FROM   [order details]
WHERE  quantity >= 60
GROUP  BY orderid,
          quantity
HAVING Count(*) > 1;

-- Ex. 39

SELECT [order details].orderid,
       productid,
       unitprice,
       quantity,
       discount
FROM   [order details]
       JOIN (SELECT DISTINCT orderid
             FROM   [order details]
             WHERE  quantity >= 60
             GROUP  BY orderid,
                       quantity
             HAVING Count(*) > 1) PotentialProblemOrders
         ON PotentialProblemOrders.orderid = [order details].orderid
ORDER  BY orderid,
          productid;

-- Ex. 40

SELECT [order details].orderid,
       productid,
       unitprice,
       quantity,
       discount
FROM   [order details]
       JOIN (SELECT DISTINCT orderid
             FROM   [order details]
             WHERE  quantity >= 60
             GROUP  BY orderid,
                       quantity
             HAVING Count(*) > 1) PotentialProblemOrders
         ON PotentialProblemOrders.orderid = [order details].orderid
ORDER  BY orderid,
          productid;

-- Ex. 41

SELECT orderid,
       OrderDate = CONVERT(DATE, orderdate),
       RequiredDate = CONVERT(DATE, requireddate),
       ShippedDate = CONVERT(DATE, shippeddate)
FROM   orders
WHERE  requireddate <= shippeddate;

-- Ex. 42

SELECT employees.employeeid,
       lastname,
       TotalLateOrders = Count(*)
FROM   orders
       JOIN employees
         ON employees.employeeid = orders.employeeid
WHERE  requireddate <= shippeddate
GROUP  BY employees.employeeid,
          employees.lastname
ORDER  BY totallateorders DESC;

-- Ex. 43 

WITH lateorders
     AS (SELECT employeeid,
                TotalOrders = Count(*)
         FROM   orders
         WHERE  requireddate <= shippeddate
         GROUP  BY employeeid),
     allorders
     AS (SELECT employeeid,
                TotalOrders = Count(*)
         FROM   orders
         GROUP  BY employeeid)
SELECT employees.employeeid,
       lastname,
       AllOrders = allorders.totalorders,
       LateOrders = lateorders.totalorders
FROM   employees
       JOIN allorders
         ON allorders.employeeid = employees.employeeid
       JOIN lateorders
         ON lateorders.employeeid = employees.employeeid;

-- Ex. 46

WITH lateorders
     AS (SELECT employeeid,
                TotalOrders = Count(*)
         FROM   orders
         WHERE  requireddate <= shippeddate
         GROUP  BY employeeid),
     allorders
     AS (SELECT employeeid,
                TotalOrders = Count(*)
         FROM   orders
         GROUP  BY employeeid)
SELECT employees.employeeid,
       lastname,
       AllOrders = allorders.totalorders,
       LateOrders = lateorders.totalorders,
       PercentLateOrders = Round(Cast(lateorders.totalorders AS FLOAT), 2) /
                           Round(Cast(
                           allorders.totalorders AS FLOAT), 2)
FROM   employees
       JOIN allorders
         ON allorders.employeeid = employees.employeeid
       JOIN lateorders
         ON lateorders.employeeid = employees.employeeid;

-- EX. 48

WITH orders2016
     AS (SELECT customers.customerid,
                customers.companyname,
                TotalOrderAmount = Sum(quantity * unitprice)
         FROM   customers
                JOIN orders
                  ON orders.customerid = customers.customerid
                JOIN [order details]
                  ON orders.orderid = [order details].orderid
         WHERE  orderdate >= '19970101'
                AND orderdate < '19980101'
         GROUP  BY customers.customerid,
                   customers.companyname)
SELECT customerid,
       companyname,
       totalorderamount,
       CustomerGroup = CASE
                         WHEN totalorderamount BETWEEN 0 AND 1000 THEN 'Low'
                         WHEN totalorderamount BETWEEN 1001 AND 5000 THEN
                         'Medium'
                         WHEN totalorderamount BETWEEN 5001 AND 10000 THEN
                         'High'
                         WHEN totalorderamount > 10000 THEN 'Very High'
                       END
FROM   orders2016
ORDER  BY customerid;

-- Ex. 49

SELECT country
FROM   customers
UNION
SELECT country
FROM   suppliers
ORDER  BY country;

-- Ex. 50

WITH ordersbycountry
     AS (SELECT shipcountry,
                customerid,
                orderid,
                OrderDate = CONVERT(DATE, orderdate),
                RowNumberPerCountry = Row_number()
                                        OVER (
                                          partition BY shipcountry
                                          ORDER BY shipcountry, orderid)
         FROM   orders)
SELECT shipcountry,
       customerid,
       orderid,
       orderdate
FROM   ordersbycountry
WHERE  rownumberpercountry = 1
ORDER  BY shipcountry; 