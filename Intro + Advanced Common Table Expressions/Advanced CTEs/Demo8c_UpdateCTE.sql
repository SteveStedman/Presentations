use JProCo;
GO

-- Update

-- simple SELECT to find specific customers
SELECT *
  FROM Customer 
 WHERE LastName like 'Williams';


-- simple CTE to do the same
;WITH CustomerCTE AS
( 
	SELECT *
      FROM Customer 
     WHERE LastName like 'Williams'
) 
SELECT * FROM CustomerCTE;





BEGIN TRANSACTION;

	SELECT COUNT(1) FROM Customer;
	SELECT * FROM Customer WHERE LastName like 'Williams';

	;WITH CustomerCTE AS
	( 
		SELECT c.*
		  FROM Customer AS c
		 WHERE c.LastName like 'Williams'
	) 
	UPDATE CustomerCTE
	   SET LastName = 'Willie';

	SELECT COUNT(1) FROM Customer;
	SELECT * FROM Customer WHERE LastName like 'Williams';
	SELECT * FROM Customer WHERE LastName like 'Willie';

ROLLBACK TRANSACTION;




-- selecting multiple Base Tables will this work?

BEGIN TRANSACTION;

	SELECT c.*, si.Comment 
	  FROM Customer AS c
	 INNER JOIN SalesInvoice AS si ON si.CustomerID = c.CustomerID
	 WHERE c.LastName like 'Williams';

	;WITH CustomerCTE AS
	( 
		SELECT c.*, si.Comment 
		  FROM Customer AS c
		 INNER JOIN SalesInvoice AS si ON si.CustomerID = c.CustomerID
		 WHERE c.LastName like 'Williams'
	) 
	UPDATE CustomerCTE
	   SET Comment = 'Some Comment Goes Here';

	SELECT c.*, si.Comment 
	  FROM Customer AS c
	 INNER JOIN SalesInvoice AS si ON si.CustomerID = c.CustomerID
	 WHERE c.LastName like 'Williams';

ROLLBACK TRANSACTION;









-- updating multiple base tables
;WITH CustomerCTE AS
( 
	SELECT c.*, si.Comment 
		FROM Customer AS c
		INNER JOIN SalesInvoice AS si ON si.CustomerID = c.CustomerID
		WHERE c.LastName like 'Williams'
) 
UPDATE CustomerCTE
    SET Comment = 'Some Comment Goes Here',
        CompanyName = 'Willies Toys';
	   
