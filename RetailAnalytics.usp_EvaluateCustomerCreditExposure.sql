CREATE PROCEDURE RetailAnalytics.usp_EvaluateCustomerCreditExposure
(
    @CustomerID INT,
    @ReturnCode INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF @CustomerID IS NULL
        BEGIN
            SET @ReturnCode = -1;

            SELECT
                NULL AS CustomerID,
                NULL AS CustomerName,
                NULL AS TotalRevenue,
                NULL AS CreditExposureLevel,
                'FAILED' AS ProcessingStatus,
                'CustomerID cannot be NULL' AS ProcessingMessage;
            RETURN;
        END

        IF NOT EXISTS
        (
            SELECT 1
            FROM Sales.Customer
            WHERE CustomerID = @CustomerID
        )
        BEGIN
            SET @ReturnCode = -2;

            SELECT
                @CustomerID AS CustomerID,
                NULL AS CustomerName,
                NULL AS TotalRevenue,
                NULL AS CreditExposureLevel,
                'FAILED' AS ProcessingStatus,
                'Invalid CustomerID' AS ProcessingMessage;

            RETURN;
        END

        DECLARE @TotalRevenue MONEY;
        DECLARE @CreditExposureLevel VARCHAR(20);
        DECLARE @CustomerName VARCHAR(200);

        SET @TotalRevenue =
        RetailAnalytics.ufn_GetCustomerTotalRevenue(@CustomerID);

   
        SET @CreditExposureLevel =
            CASE
                WHEN @TotalRevenue >= 100000 THEN 'High'
                WHEN @TotalRevenue BETWEEN 25000 AND 99999 THEN 'Medium'
                ELSE 'Low'
            END;

        SELECT
            @CustomerName =
                ISNULL(P.FirstName,'') + ' ' +
                ISNULL(P.LastName,'')
        FROM Sales.Customer C
        INNER JOIN Person.Person P
            ON C.PersonID = P.BusinessEntityID
        WHERE C.CustomerID = @CustomerID;

        SET @ReturnCode = 0;

        SELECT
            @CustomerID AS CustomerID,
            @CustomerName AS CustomerName,
            @TotalRevenue AS TotalRevenue,
            @CreditExposureLevel AS CreditExposureLevel,
            'SUCCESS' AS ProcessingStatus,
            'Customer credit exposure evaluated successfully'
                AS ProcessingMessage;

    END TRY

    BEGIN CATCH

        SET @ReturnCode = -99;

        SELECT
            @CustomerID AS CustomerID,
            NULL AS CustomerName,
            NULL AS TotalRevenue,
            NULL AS CreditExposureLevel,
            'FAILED' AS ProcessingStatus,
            ERROR_MESSAGE() AS ProcessingMessage;

    END CATCH
END;
GO