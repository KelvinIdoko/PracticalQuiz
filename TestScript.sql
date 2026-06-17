--Test 1 Valid Input

SELECT TOP 10 CustomerID
FROM Sales.Customer;
GO

DECLARE @RC INT;

EXEC RetailAnalytics.usp_EvaluateCustomerCreditExposure
     @CustomerID = 11000,
     @ReturnCode = @RC OUTPUT;

SELECT @RC AS ReturnCode;
GO


--Test 2 Invalid Input

DECLARE @RC INT;

EXEC RetailAnalytics.usp_EvaluateCustomerCreditExposure
     @CustomerID = 999999,
     @ReturnCode = @RC OUTPUT;

SELECT @RC AS ReturnCode;
GO

--Test 3 NULL Input
DECLARE @RC INT;

EXEC RetailAnalytics.usp_EvaluateCustomerCreditExposure
     @CustomerID = NULL,
     @ReturnCode = @RC OUTPUT;

SELECT @RC AS ReturnCode;
GO