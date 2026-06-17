USE AdventureWorks2022;
GO

IF NOT EXISTS
(
    SELECT *
    FROM sys.schemas
    WHERE name = 'RetailAnalytics'
)
BEGIN
    EXEC('CREATE SCHEMA RetailAnalytics');
    PRINT 'Schema RetailAnalytics created successfully.';
END
ELSE
BEGIN
    PRINT 'Schema RetailAnalytics already exists.';
END;

