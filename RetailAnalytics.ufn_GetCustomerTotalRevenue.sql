CREATE FUNCTION RetailAnalytics.ufn_GetCustomerTotalRevenue
(
    @CustomerID INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @TotalRevenue MONEY;

    SELECT @TotalRevenue = ISNULL(SUM(TotalDue), 0)
    FROM Sales.SalesOrderHeader
    WHERE CustomerID = @CustomerID;

    RETURN @TotalRevenue;
END;
GO