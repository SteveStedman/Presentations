use JProCo;
GO

-- Insert

-- simple SELECT to find specific customers
SELECT *
  FROM Customer 
 WHERE LastName like 'Stedman';


-- simple CTE to do the same
;WITH CustomerCTE AS
( 
	SELECT *
      FROM Customer 
     WHERE LastName like 'Stedman'
) 
SELECT * FROM CustomerCTE;







BEGIN TRANSACTION;

	SELECT COUNT(1) FROM Customer;
	SELECT * FROM Customer WHERE LastName like 'Stedman';

	;WITH CustomerCTE AS
	( 
		SELECT *
			FROM Customer 
			WHERE LastName like 'Stedman'
	) 
	INSERT INTO CustomerCTE
            (CustomerID, FirstName, LastName)
     VALUES (99999, 'Steve', 'Stedman');

	SELECT COUNT(1) FROM Customer;
	SELECT * FROM Customer WHERE LastName like 'Stedman';

ROLLBACK TRANSACTION;




-- selecting multiple Base Tables will this work?

BEGIN TRANSACTION;

	SELECT COUNT(1) AS NumCustomers FROM Customer;
	SELECT COUNT(1) AS NumInvoices FROM SalesInvoice;
	SELECT * FROM Customer WHERE LastName like 'Stedman';

	;WITH CustomerCTE AS
	( 
		SELECT c.*
		  FROM Customer AS c
		 INNER JOIN SalesInvoice AS si ON si.CustomerID = c.CustomerID
		 WHERE c.LastName like 'Stedman'
	) 
	INSERT INTO CustomerCTE
            (CustomerID, FirstName, LastName)
     VALUES (99999, 'Steve', 'Stedman');

	SELECT COUNT(1) AS NumCustomers FROM Customer;
	SELECT COUNT(1) AS NumInvoices FROM SalesInvoice;
	SELECT * FROM Customer WHERE LastName like 'Stedman';

ROLLBACK TRANSACTION;







-- updating multiple base tables

;WITH CustomerCTE AS
( 
	SELECT c.*, si.comment
		FROM Customer AS c
		INNER JOIN SalesInvoice AS si ON si.CustomerID = c.CustomerID
		WHERE c.LastName like 'Stedman'
) 
INSERT INTO CustomerCTE
        (CustomerID, FirstName, LastName, comment)
    VALUES (99999, 'Steve', 'Stedman', 'Test Comment');
