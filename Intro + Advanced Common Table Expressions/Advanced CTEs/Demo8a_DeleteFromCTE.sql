use JProCo;
GO

-- Delete

-- simple SELECT to find customers name Williams
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


--NOTE above queries produce 12 results




BEGIN TRANSACTION;

	SELECT COUNT(1) FROM Customer;
	SELECT * FROM Customer WHERE LastName like 'Williams';


	;WITH CustomerCTE AS
	( 
		SELECT *
			FROM Customer 
			WHERE LastName like 'Williams'
	) 
	DELETE FROM CustomerCTE;


	SELECT * FROM Customer WHERE LastName like 'Williams';
	SELECT COUNT(1) FROM Customer;

ROLLBACK TRANSACTION;






-- deleting from multiple base tables
BEGIN TRANSACTION;


	SELECT COUNT(1) FROM Customer;
	SELECT * FROM Customer WHERE LastName like 'Williams';


	;WITH CustomerCTE AS
	( 
		SELECT c.*
			FROM Customer AS c
			INNER JOIN SalesInvoice AS si ON si.CustomerID = c.CustomerID
			WHERE c.LastName like 'Williams'
	) 
	DELETE FROM CustomerCTE;


	SELECT * FROM Customer WHERE LastName like 'Williams';
	SELECT COUNT(1) FROM Customer;


ROLLBACK TRANSACTION;
   

