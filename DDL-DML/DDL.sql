IF DB_ID('Book_Seller') IS NULL
	CREATE DATABASE Book_Seller
GO
USE Book_Seller
GO
CREATE TABLE Publishers
(
   PublisherID INT PRIMARY KEY,
   PublisherName NVARCHAR(30) NOT NULL
)
GO
CREATE TABLE Genres
(
    GenreID INT PRIMARY KEY,
	GenreName NVARCHAR(30) NOT NULL
)
GO
CREATE TABLE Books
(
   bookID INT PRIMARY KEY,
   Title NVARCHAR(30) NOT NULL,
   GenreID INT NOT NULL REFERENCES Genres(GenreID),
   Price MONEY NOT NULL,
   PublishDate DATE NOT NULL,
   PublisherID INT NOT NULL REFERENCES Publishers(PublisherID)
)
GO
CREATE TABLE Authors
(
   AuthorID INT PRIMARY KEY,
   AuthorName NVARCHAR(40) NOT NULL,
   Aaddress NVARCHAR(70) NOT NULL
)
GO
CREATE TABLE BookAuthors
(
   AuthorID INT NOT NULL REFERENCES Authors(AuthorID),
   bookID INT NOT NULL REFERENCES Books(bookID),
   PRIMARY KEY(AuthorID, bookID)
)
GO
CREATE TABLE Customers
(
    CustomerID INT PRIMARY KEY,
	CustomerName NVARCHAR(30) NOT NULL
)
GO
CREATE TABLE Sales 
(
   SaleID INT PRIMARY KEY,
   CustomerID INT NOT NULL REFERENCES Customers(CustomerID),
   SalesDate DATE NOT NULL
)
GO
CREATE TABLE SaleDetails
(
   SaleID INT NOT NULL REFERENCES Sales(SaleID),
   bookID INT NOT NULL REFERENCES Books(bookID),
   NumberOfBook INT NOT NULL,
   PRIMARY KEY(SaleID,bookID)
)
GO
SELECT * FROM Publishers
Go
--DDL Statment
CREATE PROC spInsertPublishers @pn NVARCHAR(30), @id INT OUTPUT
AS
DECLARE @i INT
SELECT @i = ISNULL(MAX(PublisherID), 0)+1 FROM Publishers
BEGIN TRY INSERT INTO Publishers(PublisherID, PublisherName)
           VALUES(@i, @pn)
		   SET @id = @i
		   RETURN 0
END TRY
BEGIN CATCH
     DECLARE @msg NVARCHAR(1000), @err INT
	 SELECT @msg = ERROR_MESSAGE(), @err = ERROR_NUMBER()
	 ;
	 THROW 50001, @msg, 1
	 RETURN @err
END CATCH
GO

--insert Proc Generes
CREATE PROC spInsertGenres @gn NVARCHAR(30), @gi INT OUTPUT
AS
DECLARE @id INT
SELECT @id = ISNULL(MAX(GenreID), 0)+1 FROM Genres
BEGIN TRY INSERT INTO Genres(GenreID, GenreName)
           VALUES(@id, @gn)
		   SET @gi = @id
		   RETURN 0
END TRY
BEGIN CATCH
     DECLARE @msg NVARCHAR(1000), @err INT
	 SELECT @msg = ERROR_MESSAGE(), @err = ERROR_NUMBER()
	 ;
	 THROW 50001, @msg, 1
	 RETURN @err
END CATCH
GO


--inser Proc books

CREATE PROC spInsertBooks @id INT,
                          @t NVARCHAR(30),
						  @gid INT,
						  @p MONEY,
						  @Pd DATE,
						  @pid INT,
						  @bi INT OUTPUT

AS
SELECT @id = ISNULL(MAX(bookID), 0)+1 FROM Books
BEGIN TRY INSERT INTO Books(bookID, Title, GenreID, Price, PublishDate, PublisherID)
           VALUES(@id,@t, @gid, @p, @Pd, @pid)
		   SET @bi = @id
		   RETURN 0
END TRY
BEGIN CATCH
     DECLARE @msg NVARCHAR(1000), @err INT
	 SELECT @msg = ERROR_MESSAGE(), @err = ERROR_NUMBER()
	 ;
	 THROW 50001, @msg, 1
	 RETURN @err
END CATCH
GO
SELECT * FROM Books
Go
 --insert proc Athors

CREATE PROC spInsertAuthors @id INT,
                            @an NVARCHAR(40),
						    @aad NVARCHAR(70),	
							@ai INT OUTPUT
AS
SELECT @id = ISNULL(MAX(AuthorID), 0)+1 FROM Authors
BEGIN TRY INSERT INTO Authors(AuthorID, AuthorName, Aaddress)
           VALUES(@id,@an,@aad)
		   SET @ai = @id
		   RETURN 0
END TRY
BEGIN CATCH
    DECLARE @msg NVARCHAR(1000), @err INT
	 SELECT @msg = ERROR_MESSAGE(), @err = ERROR_NUMBER()
	 ;
	 THROW 50001, @msg, 1
	 RETURN @err
END CATCH
GO


--insert Proc BooksAuthors

CREATE PROC spInsertBookAuthors @aid INT,
                                @bid INT				        				    
AS

BEGIN TRY INSERT INTO BookAuthors(AuthorID, bookID)
           VALUES(@aid, @bid)
END TRY
BEGIN CATCH
     DECLARE @msg NVARCHAR(1000)
	 SELECT @msg = ERROR_MESSAGE()
	 ;
	 THROW 50001, @msg, 1
END CATCH
GO


--insert Proc Customers

CREATE PROC spInsertCustomers @id INT,
                              @cn NVARCHAR(30), @ci INT OUTPUT					    			    
AS
SELECT @id = ISNULL(MAX(CustomerID), 0)+1 FROM Customers
BEGIN TRY INSERT INTO Customers(CustomerID, CustomerName)
           VALUES(@id, @cn)
		   SET @ci = @id 

END TRY
BEGIN CATCH
     DECLARE @msg NVARCHAR(1000)
	 SELECT @msg = ERROR_MESSAGE()
	 ;
	 THROW 50001, @msg, 1
END CATCH
GO


--insert Proc Sales

CREATE PROC spInsertSales @id INT,
                          @cid INT,
						  @sd DATE				    
AS
SELECT @id = ISNULL(MAX(SaleID), 0)+1 FROM Sales
BEGIN TRY INSERT INTO Sales(SaleID, CustomerID, SalesDate)
           VALUES(@id, @cid, @sd)
END TRY
BEGIN CATCH
     DECLARE @msg NVARCHAR(1000)
	 SELECT @msg = ERROR_MESSAGE()
	 ;
	 THROW 50001, @msg, 1
END CATCH
GO


--insert Proc SaleDetails

CREATE PROC spInsertSaleDetails @id INT,
                                @bid INT,
						        @nb INT			    
AS
SELECT @id = ISNULL(MAX(SaleID), 0)+1 FROM SaleDetails
BEGIN TRY INSERT INTO SaleDetails(SaleID, bookID, NumberOfBook)
           VALUES(@id, @bid, @nb)
END TRY
BEGIN CATCH
     DECLARE @msg NVARCHAR(1000)
	 SELECT @msg = ERROR_MESSAGE()
	 ;
	 THROW 50001, @msg, 1
END CATCH
GO
SELECT * FROM SaleDetails
GO

--Update Procidure
CREATE PROC spUdateBooks @id INT,
						 @p MONEY,
						 @Pd DATE
AS
BEGIN TRY 
      UPDATE Books 
	  SET   Price = @p, PublishDate = @Pd
	  WHERE bookID = @id
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO

--Update Proc Publishers

CREATE PROC spUdatePublishers @id INT,
                              @pn NVARCHAR(30)
AS
BEGIN TRY 
      UPDATE Publishers 
	  SET  PublisherName = @pn
	  WHERE PublisherID = @id
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO

--Update Proc Genres

CREATE PROC spUdateGenres @id INT,
                          @gn NVARCHAR(30)
AS
BEGIN TRY 
      UPDATE Genres 
	  SET  GenreName = @gn
	  WHERE GenreID = @id
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO


--Update Proc Authors

CREATE PROC spUdateAuthors @aid INT,
                           @an NVARCHAR(40),
						   @aAdd NVARCHAR(70)
AS
BEGIN TRY 
      UPDATE Authors 
	  SET  AuthorName = @an, Aaddress = @aAdd
	  WHERE AuthorID = @aid
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO


--Update Proc BookAuthors

CREATE PROC spUdateBookAuthors @aid INT,
                               @bid INT
AS
BEGIN TRY 
      UPDATE BookAuthors 
	  SET  bookID = @bid
	  WHERE AuthorID = @aid
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO

--Update Proc Customers

CREATE PROC spUdateCustomers @id INT,
                             @cn NVARCHAR(30)
AS
BEGIN TRY 
      UPDATE Customers 
	  SET  CustomerName = @cn
	  WHERE CustomerID = @id
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO

--Update Proc Sales

CREATE PROC spUdateSales @sid INT,
                         @cid INT,
						 @sdate DATE
AS
BEGIN TRY 
      UPDATE Sales 
	  SET  CustomerID = @cid, SalesDate = @sdate
	  WHERE SaleID = @sid
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO


--Update Proc SaleDetails

CREATE PROC spUdateSaleDetails @sid INT,
							   @nob INT
AS
BEGIN TRY 
      UPDATE SaleDetails 
	  SET NumberOfBook = @nob
	  WHERE SaleID = @sid
END TRY
BEGIN CATCH
	 ;
	 THROW 50002, 'Update Faild', 1
END CATCH
GO
SELECT * FROM SaleDetails
GO

--Delete Procidure
CREATE PROC spDeletePublishers @id INT
AS
BEGIN TRY
      DELETE Publishers
	  WHERE PublisherID = @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO

--Delete proc Genres

CREATE PROC spDeleteGenres @id INT                         
AS
BEGIN TRY
      DELETE Genres
	  WHERE GenreID = @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO


--Delete Proc Books

CREATE PROC spDeleteBooks @id INT
AS
BEGIN TRY
      DELETE Books
	  WHERE bookID = @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO

--Delete Proc Authors

CREATE PROC spDeleteAuthors @id INT
AS
BEGIN TRY
      DELETE Authors
	  WHERE  AuthorID= @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO

--Delete Proc BookAuthors

CREATE PROC spDeleteBookAuthors @id INT
AS
BEGIN TRY
      DELETE BookAuthors
	  WHERE  AuthorID= @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO

--Delete Proc Customers

CREATE PROC spDeleteCustomers @id INT
AS
BEGIN TRY
      DELETE Customers
	  WHERE  CustomerID= @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO

--Delete Proc Sales

CREATE PROC spDeleteSales @id INT
AS
BEGIN TRY
      DELETE Sales
	  WHERE  SaleID= @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO

--Delete Proc SalesDetails

CREATE PROC spDeleteSaleDetails @id INT
AS
BEGIN TRY
      DELETE SaleDetails
	  WHERE SaleID= @id
END TRY
BEGIN CATCH
         ;
		 THROW 50001, 'Can''t deleted', 1
END CATCH
GO


--Create Function

--Scalar UDF
--Books published in a particular year
CREATE FUNCTION fnBooksPublished(@year INT) RETURNS INT
AS
BEGIN
    DECLARE @c INT 
	SELECT @c = COUNT(*) FROM Books
	WHERE YEAR(PublishDate) = @year
	RETURN @c
END
GO

--DataType Return Function

CREATE FUNCTION fnSalesInfo(@sid INT) RETURNS INT
AS
BEGIN
    DECLARE @c INT 
	SELECT @c = COUNT(*) FROM Sales
	WHERE SaleID = @sid
	RETURN @c
END
GO

--DataType Return Function

CREATE FUNCTION fnCustomerInfo(@cid INT) RETURNS INT
AS
BEGIN
    DECLARE @c INT 
	SELECT @c = COUNT(*) FROM Customers
	WHERE CustomerID = @cid
	RETURN @c
END
GO
--DataType Return Function

CREATE FUNCTION fnAuthorsInfo(@aid INT) RETURNS INT
AS
BEGIN
    DECLARE @c INT 
	SELECT @c = COUNT(*) FROM Authors
	WHERE AuthorID = @aid
	RETURN @c
END
GO
--Table Function

CREATE FUNCTION fnBooksInfo(@bk int) RETURNS TABLE
AS
RETURN
(
 SELECT b.bookID,ba.AuthorID,a.AuthorName, b.Title, b.PublishDate, b.Price,
       s.SalesDate, sd.NumberOfBook,a.Aaddress
 FROM Sales s 
 INNER JOIN SaleDetails sd ON s.SaleID=sd.SaleID
 INNER JOIN  Books b ON sd.bookID =b.bookID
 INNER JOIN BookAuthors ba ON b.bookID=ba.bookID
 INNER JOIN Authors a ON ba.AuthorID = a.AuthorID
 WHERE b.bookID = @bk
)
GO
CREATE FUNCTION fnSalesDetailsInfo(@gn int) RETURNS TABLE
AS
RETURN
(
 SELECT g.GenreID,g.GenreName, p.PublisherName, b.PublishDate, b.Price
 FROM Genres g
 INNER JOIN Books b ON g.GenreID=b.GenreID
 INNER JOIN Publishers p ON b.PublisherID=p.PublisherID
 WHERE g.GenreID=@gn
)
GO








CREATE VIEW vBooksBypublisher 
AS 
 (SELECT b.bookID, b.Title, b.Price, p.PublisherName, b.PublishDate
  FROM Books b
  INNER JOIN Publishers p ON b.PublisherID = p.PublisherID
 )
GO

----Create View BooksBySaleDetails

CREATE VIEW vBooksBySaleDetails 
AS 
 (SELECT b.Title, b.Price, b.PublishDate, s.NumberOfBook
  FROM Books b
  INNER JOIN SaleDetails s ON b.bookID= s.bookID
 )
GO

-----Create View BooksByBookAuthors

CREATE VIEW vBooksByBookAuthors
AS
  SELECT bk.bookID, bk.AuthorID, b.Title, b.Price
  FROM Books b
  INNER JOIN BookAuthors bk ON b.bookID = bk.bookID
GO


----Create View BooksByGenres

CREATE VIEW vBooksByGenres
AS
  SELECT b.GenreID, g.GenreName, b.Price
  FROM Books b
  INNER JOIN Genres g ON b.GenreID = g.GenreID
GO
SELECT * FROM vBooksByGenres
GO

CREATE VIEW vCustomerBysaleInfo
AS
  (SELECT c.CustomerID, s.SaleID, c.CustomerName, sd.NumberOfBook, s.SalesDate 
  FROM Customers c
  INNER JOIN Sales s ON c.CustomerID= s.CustomerID
  INNER JOIN SaleDetails sd ON s.SaleID = sd.SaleID)
GO
--***Create Insert Tigger***

CREATE TRIGGER trInsertBook
ON Books
FOR INSERT 
AS
BEGIN
    DECLARE @pd DATE
	SELECT @pd = PublishDate FROM inserted
	IF CAST(@pd AS DATE)> CAST(GETDATE() AS DATE)
	BEGIN
	    RAISERROR('Invalid data', 11, 1)
		ROLLBACK Transaction
	END
END
GO

--****Create View*****
--Create InsertTrigger Sales--

CREATE TRIGGER trInsertSale
ON Sales
FOR INSERT 
AS
BEGIN
    DECLARE @sd DATE
	SELECT @sd = SalesDate FROM inserted
	IF CAST(@sd AS DATE)> CAST(GETDATE() AS DATE)
	BEGIN
	    RAISERROR('Invalid data', 11, 1)
		ROLLBACK Transaction
	END
END
GO


CREATE TRIGGER trInsertSaleDetails
ON SaleDetails
FOR INSERT 
AS
BEGIN
    DECLARE @nob INT
	SELECT @nob = NumberOfBook FROM inserted
	IF(@nob>1000)
	BEGIN
	    RAISERROR('Invalid data', 11, 1)
		ROLLBACK Transaction
	END
END
GO

--***CREATE Delete Trigger***


--Dlete Trigger Authors

CREATE TRIGGER trAuthorDelete
ON Authors
AFTER DELETE 
AS
BEGIN 
    DECLARE @id INT 
	SELECT @id =AuthorID  FROM deleted 
	IF EXISTS (SELECT 1 FROM BookAuthors WHERE AuthorID=@id)
	BEGIN
	    ROLLBACK Transaction 
		RAISERROR ('Author has dependedent book. Delete them frist', 16, 1)
		RETURN
	END
END
GO

--Dlete Trigger Sales

CREATE TRIGGER teDeleteSales
ON Sales 
FOR DELETE
AS
BEGIN
    DECLARE @sd DATE
	SELECT @sd = SalesDate FROM deleted
	IF @sd IS NOT NULL
	BEGIN 
	    ROLLBACK Transaction
		RAISERROR ('Already delivered order, action cencelled.', 11, 1)
	END
END
GO


--Dlete Trigger Genres

CREATE TRIGGER teDeleteGenres
ON Genres 
FOR DELETE
AS
BEGIN
    DECLARE @gid INT
	SELECT  @gid = GenreID FROM deleted
	IF @gid IS NOT NULL
	BEGIN 
	    ROLLBACK Transaction
		RAISERROR ('Already delivered order, action cencelled.', 11, 1)
	END
END
GO
