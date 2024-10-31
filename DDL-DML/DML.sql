USE Book_Seller
GO
INSERT INTO Authors VALUES 
(1,'Anisul Hoque','Nilphamari'),
(2,'Al Mahmud','Brahmanbaria '),
(3,'Begum Rokeya','Rangpur'),
(4,'Humayun Azad','Bikrampur')
GO
INSERT INTO Genres VALUES
(1,'Science Fiction'),
(2,'Biographical'),
(3,'Religious & Inspirational'),
(4,'Historical'),
(5,'Family Life')
GO
INSERT INTO Publishers VALUES
(1,'AALOKAYAN'),
(2,'ALOGHAR PROKASHONA'),
(3,'Abir Prokashan'),
(4,'Apon Prokash'),
(5,'Ayan Prokasho')
GO
INSERT INTO Books VALUES
(1,'Chokher Bali',3 ,300.00 ,'2022-06-01',3 ),
(2,'Pather Panchali',5,180.00,'2022-04-01',2),
(3,'Shesher Kabita',3,120.00,'2022-02-06',5),
(4,'Devdas',2,100.00,'2022-04-03',2),
(5,'Anandamath',5,160.00,'2022-09-04',1),
(6,'Durgeshnandini',4,199.00,'2022-08-06',3),
(7,'Lalsalu',2,250.00,'2022-02-03',5),
(8,'Kapalkundala',3,300.00,'2022-04-06',4),
(9,'Chander Pahar',2,160.00,'2022-01-13',1),
(10,'Kuhelika',1,180.00,'2022-07-01',3)
GO
INSERT INTO BookAuthors VALUES
(1,2),(1,10),(2,3),(2,6),(2,9),(3,8),(3,5),(3,4),(4,8),(4,6)
GO
INSERT INTO Customers VALUES
(1,'Rakib'),(2,'Salim'),(3,'Nurnahar'),(4,'Asik'),
(5,'Aysha'),(6,'Monir'),(7,'Joba'),(8,'Mousumi'),
(9,'Roni'),(10,'Mahim'),(11,'Akib'),(12,'Shohel'),
(13,'ABDUl'),(14,'Musa'),(15,'Sohan')
GO
INSERT INTO Sales VALUES
(1,2, GETDATE()),(2,4, GETDATE()),(3,8, GETDATE()),(4,9, GETDATE()),(5,5, GETDATE()),(6,10, GETDATE()),
(7,7, GETDATE()),(8,13, GETDATE()),(9,8, GETDATE()),(10,12, GETDATE()),(11,14, GETDATE())
GO
INSERT INTO SaleDetails VALUES 
(1,3,5),(1,2,4),(2,5,7),(2,3,9),
(3,4,2),(3,6,1),
(4,6,9),
(5,7,5),(5,5,8),
(6,1,9),(6,3,1),(6,7,8),
(8,3,5),
(9,4,7),(9,7,9)
GO
SELECT * FROM Authors
SELECT * FROM Genres
SELECT * FROM Publishers
SELECT * FROM Books
SELECT * FROM BookAuthors
SELECT * FROM Customers
SELECT * FROM Sales
SELECT * FROM SaleDetails
GO
--CTE
WITH CTE AS
(
   SELECT bookID, Title, Price, PublishDate, GenreID
   FROM Books
)
SELECT g.GenreID, g.GenreName, CTE.Title, CTE.PublishDate
FROM Genres g
INNER JOIN CTE ON g.GenreID = CTE.GenreID
GO

--Sub-query
SELECT sub.*
FROM (SELECT b.bookID,a.AuthorID, b.Title, a.AuthorName, s.SalesDate, 
                  Count(s.SaleID) 'Total sale'
      FROM Authors a
	  INNER JOIN BookAuthors ba ON a.AuthorID= ba.AuthorID
	  INNER JOIN Books b ON ba.bookID= b.bookID
	  INNER JOIN SaleDetails sd ON b.bookID=sd.bookID
	  INNER JOIN Sales s ON sd.SaleID= s.SaleID
	  GROUP BY b.bookID,a.AuthorID, b.Title, a.AuthorName, s.SalesDate
	  ) as sub
WHERE sub.[Total sale] > 1

GO
WITH CTE AS
(
  SELECT bookID, Title, Price, PublishDate
  FROM Books 
)
SELECT CTE.bookID, sd.SaleID, CTE.Title, CTE.Price, CTE.PublishDate, sd.NumberOfBook
FROM SaleDetails sd
INNER JOIN CTE ON sd.bookID= CTE.bookID
GO

--Create CTE as bi
WITH bi AS
(
  SELECT bookID, Title, GenreID, Price, PublishDate, PublisherID
  FROM  Books b
)
SELECT a.AuthorID, ba.bookID, a.AuthorName, bi.PublishDate, bi.Price
FROM Authors a
INNER JOIN BookAuthors ba ON a.AuthorID = ba.AuthorID
INNER JOIN bi ON ba.bookID=bi.bookID
GO


--Create CTE as Cus
WITH Cus AS
 (
   SELECT CustomerID, CustomerName
   FROM Customers
 )
SELECT * 
FROM SaleDetails sd 
INNER JOIN Sales s ON sd.SaleID = s.SaleID
INNER JOIN Cus ON s.CustomerID = Cus.CustomerID
GO

--Create CTE as Au
WITH Au AS
 (
   SELECT AuthorID, AuthorName, Aaddress
   FROM Authors 
 )
SELECT Au.AuthorID, ba.bookID, Au.AuthorName, Au.Aaddress 
FROM BookAuthors ba
INNER JOIN Au ON ba.AuthorID = Au.AuthorID
GO

--View
SELECT * FROM vBooksByGenres
GO
SELECT * FROM vCustomerBysaleInfo
GO
--UDF
SELECT  dbo.fnBooksPublished('2022')
GO
SELECT dbo.fnSalesInfo(1)
GO
SELECT dbo.fnCustomerInfo(1)
GO
SELECT dbo.fnAuthorsInfo(1)
GO
SELECT * FROM fnBooksInfo(1)
GO
SELECT * FROM fnSalesDetailsInfo(1)
GO
--Procedure
DECLARE @id INT
EXEC spInsertPublishers 'Sagor Publishers', @id OUTPUT
GO
DECLARE @id INT
EXEC spInsertGenres 'POEM', @id OUTPUT
GO
DECLARE @id INT
EXEC spInsertBooks @id =999,
                          @t ='Shesher Kabita',
						  @gid =1,
						  @p =100,
						  @Pd ='2022-03-20',
						  @pid = 1,
						  @bi = @id OUTPUT
GO
DECLARE @id INT
EXEC spInsertAuthors @id =999,
                            @an = 'Anisul Hoque',
						    @aad ='DHAKA',
							@ai = @id OUTPUT
GO
EXEC spInsertBookAuthors @aid =1, @bid =1
GO
DECLARE @id INT
EXEC spInsertCustomers @id =9999,
                              @cn ='BILLAH', @ci = @id OUTPUT
GO
DECLARE @d DATE
SET @d = GETDATE()
EXEC spInsertSales @id =9999,
                          @cid =1,
						  @sd = @d
GO
EXEC spUdateBooks @id =1,
						 @p = 300,
						 @Pd ='2022-03-14'

GO
--Trigger
INSERT INTO Books VALUES
(99,'Devdas',2 ,200.00 ,'2021-06-01',3 )
GO
INSERT INTO Sales VALUES
(99,1,'2021-01-01')
GO
/*
 *		Queries 
 * */
-- 1 INNER JOIN
SELECT        p.PublisherName,g.GenreName, b.Title, b.Price, b.PublishDate, a.AuthorName, s.CustomerID, s.SalesDate, sd.NumberOfBook
FROM            Publishers p
INNER JOIN
                         Books b ON p.PublisherID = b.PublisherID 
INNER JOIN
                         BookAuthors ba ON b.bookID = ba.bookID 
INNER JOIN
                         Genres g ON b.GenreID = g.GenreID 
INNER JOIN
                         SaleDetails sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors a ON ba.AuthorID = a.AuthorID
GO
--2 Inner join filter
SELECT        p.PublisherName,g.GenreName, b.Title, b.Price, b.PublishDate, a.AuthorName, s.CustomerID, s.SalesDate, sd.NumberOfBook
FROM            Publishers p
INNER JOIN
                         Books b ON p.PublisherID = b.PublisherID 
INNER JOIN
                         BookAuthors ba ON b.bookID = ba.bookID 
INNER JOIN
                         Genres g ON b.GenreID = g.GenreID 
INNER JOIN
                         SaleDetails sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors a ON ba.AuthorID = a.AuthorID
WHERE p.PublisherName = 'ALOGHAR PROKASHONA'
GO
--3 Inner join another filter
SELECT        p.PublisherName,g.GenreName, b.Title, b.Price, b.PublishDate, a.AuthorName, s.CustomerID, s.SalesDate, sd.NumberOfBook
FROM            Publishers p
INNER JOIN
                         Books b ON p.PublisherID = b.PublisherID 
INNER JOIN
                         BookAuthors ba ON b.bookID = ba.bookID 
INNER JOIN
                         Genres g ON b.GenreID = g.GenreID 
INNER JOIN
                         SaleDetails sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors a ON ba.AuthorID = a.AuthorID
WHERE g.GenreName= 'Historical'
GO
--4 Right outer
SELECT					p.PublisherName, g.GenreName, b.Title, b.Price, b.PublishDate, a.AuthorName, s.CustomerID, s.SalesDate, sd.NumberOfBook
FROM					BookAuthors AS ba 
INNER JOIN
                         Books AS b ON ba.bookID = b.bookID 
INNER JOIN
                         SaleDetails AS sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales AS s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors AS a ON ba.AuthorID = a.AuthorID 
RIGHT OUTER JOIN
                         Genres AS g ON b.GenreID = g.GenreID 
RIGHT OUTER JOIN
                         Publishers AS p ON b.PublisherID = p.PublisherID
GO
--5 Change 4 to CTE
WITH cte AS
(
SELECT					b.PublisherID, b.GenreID, b.Title, b.Price, b.PublishDate, a.AuthorName, s.CustomerID, s.SalesDate, sd.NumberOfBook
FROM					BookAuthors AS ba 
INNER JOIN
                         Books AS b ON ba.bookID = b.bookID 
INNER JOIN
                         SaleDetails AS sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales AS s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors AS a ON ba.AuthorID = a.AuthorID 
)
SELECT p.PublisherName, g.GenreName,c.Title, c.Price, c.PublishDate, c.AuthorName, c.CustomerID, c.SalesDate, c.NumberOfBook
FROM cte c
RIGHT OUTER JOIN
                         Genres AS g ON c.GenreID = g.GenreID 

RIGHT OUTER JOIN
                         Publishers AS p ON c.PublisherID = p.PublisherID
GO
--6 Right outer not-matched
SELECT					p.PublisherName, g.GenreName, b.Title, b.Price, b.PublishDate, a.AuthorName, s.CustomerID, s.SalesDate, sd.NumberOfBook
FROM					BookAuthors AS ba 
INNER JOIN
                         Books AS b ON ba.bookID = b.bookID 
INNER JOIN
                         SaleDetails AS sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales AS s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors AS a ON ba.AuthorID = a.AuthorID 
RIGHT OUTER JOIN
                         Genres AS g ON b.GenreID = g.GenreID 
RIGHT OUTER JOIN
                         Publishers AS p ON b.PublisherID = p.PublisherID
WHERE g.GenreID IS NULL
GO
--7 Right outer not-matched sub-query
SELECT					p.PublisherName, g.GenreName, b.Title, b.Price, b.PublishDate, a.AuthorName, s.CustomerID, s.SalesDate, sd.NumberOfBook
FROM					BookAuthors AS ba 
INNER JOIN
                         Books AS b ON ba.bookID = b.bookID 
INNER JOIN
                         SaleDetails AS sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales AS s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors AS a ON ba.AuthorID = a.AuthorID 
RIGHT OUTER JOIN
                         Genres AS g ON b.GenreID = g.GenreID 
RIGHT OUTER JOIN
                         Publishers AS p ON b.PublisherID = p.PublisherID
WHERE NOT (g.GenreID IS NOT NULL AND g.GenreID IN (SELECT GenreID FROM Genres))
GO
--8 aggregate
SELECT        p.PublisherName,g.GenreName, COUNT(b.BookId) 'count'
FROM            Publishers p
INNER JOIN
                         Books b ON p.PublisherID = b.PublisherID 
INNER JOIN
                         BookAuthors ba ON b.bookID = ba.bookID 
INNER JOIN
                         Genres g ON b.GenreID = g.GenreID 
INNER JOIN
                         SaleDetails sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors a ON ba.AuthorID = a.AuthorID
GROUP BY  p.PublisherName,g.GenreName
GO
--9 aggregate + having
SELECT        p.PublisherName,g.GenreName, COUNT(b.BookId) 'count'
FROM            Publishers p
INNER JOIN
                         Books b ON p.PublisherID = b.PublisherID 
INNER JOIN
                         BookAuthors ba ON b.bookID = ba.bookID 
INNER JOIN
                         Genres g ON b.GenreID = g.GenreID 
INNER JOIN
                         SaleDetails sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors a ON ba.AuthorID = a.AuthorID
GROUP BY  p.PublisherName,g.GenreName
HAVING g.GenreName = 'Family Life'
GO
--10 ranking
SELECT        p.PublisherName,g.GenreName, 
COUNT(b.BookId) OVER(ORDER BY p.PublisherId,g.GenreID) 'count',
ROW_NUMBER() OVER(ORDER BY p.PublisherId,g.GenreID) 'ROW',
rank() OVER(ORDER BY p.PublisherId,g.GenreID) 'RANK',
DENSE_RANK() OVER(ORDER BY p.PublisherId,g.GenreID) 'DENSE',
NTILE(3) OVER(ORDER BY p.PublisherId,g.GenreID) 'ntile'
FROM            Publishers p
INNER JOIN
                         Books b ON p.PublisherID = b.PublisherID 
INNER JOIN
                         BookAuthors ba ON b.bookID = ba.bookID 
INNER JOIN
                         Genres g ON b.GenreID = g.GenreID 
INNER JOIN
                         SaleDetails sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors a ON ba.AuthorID = a.AuthorID


GO
--11 CASE
SELECT					p.PublisherName, 
CASE 
WHEN g.GenreName IS NULL THEN 'no genre'
ELSE g.GenreName 
END GenreName, COUNT(b.bookid)
FROM					BookAuthors AS ba 
INNER JOIN
                         Books AS b ON ba.bookID = b.bookID 
INNER JOIN
                         SaleDetails AS sd ON b.bookID = sd.bookID 
INNER JOIN
                         Sales AS s ON sd.SaleID = s.SaleID 
INNER JOIN
                         Authors AS a ON ba.AuthorID = a.AuthorID 
RIGHT OUTER JOIN
                         Genres AS g ON b.GenreID = g.GenreID 
RIGHT OUTER JOIN
                         Publishers AS p ON b.PublisherID = p.PublisherID
GROUP BY  p.PublisherName,g.GenreName