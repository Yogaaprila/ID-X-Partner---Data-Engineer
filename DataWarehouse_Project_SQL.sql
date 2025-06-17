USE DWH;

-- CREATE NEW DIMENSIONAL TABLE
CREATE TABLE DimBranch(
	BranchID INT NOT NULL,
	BranchName VARCHAR(100),
	BranchLocation VARCHAR(100),
	CONSTRAINT PK_BranchID Primary Key (BranchID)
);

CREATE TABLE DimCustomer(
	CustomerID INT NOT NULL,
	CustomerName VARCHAR(100),
	Address VARCHAR(200),
	CityName VARCHAR(50),
	StateName VARCHAR(50),
	Age INT,
	Gender VARCHAR(20),
	Email VARCHAR (50),
	CONSTRAINT PK_CustomerID Primary Key (CustomerID)
);

CREATE TABLE DimAccount (
    AccountID INT NOT NULL,
    CustomerID INT NOT NULL,
	AccountType VARCHAR(40),
    Balance INT,
    DateOpened DATETIME2(0),
    Status VARCHAR(50),
    CONSTRAINT PK_AccountID PRIMARY KEY (AccountID),
	CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID)
);

CREATE TABLE FactTransaction (
	TransactionID INT NOT NULL,
	AccountID INT NOT NULL,
	TransactionDate DATETIME2(0),
	Amount INT,
	TransactionType VARCHAR(50),
	BranchID INT NOT NULL,
	CONSTRAINT PK_TransactionID PRIMARY KEY (TransactionID),
	CONSTRAINT FK_AccountID FOREIGN KEY (AccountID) REFERENCES DimAccount(AccountID),
	CONSTRAINT FK_BranchID FOREIGN KEY (BranchID) REFERENCES DimBranch(BranchID)
);

SELECT * FROM DimAccount;
SELECT * FROM DimBranch;
SELECT * FROM DimCustomer;
SELECT * FROM FactTransaction;

---- ETL PROCESS
--STAGING - DWH
--BRANCH -> DIMBRANCH
--ACCOUNT ->  DIMACCOUNT
--TRANSACTION_COMBINE -> FACTTRANSACTION
--CUSTOMER,CITY,STATE -> DIMCUSTOMER


-- CREATE STORE PROCEDURES (DAILY TRANSACTIONS)
CREATE PROCEDURE DailyTransaction
    @start_date DATE,
    @end_date DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        CAST(TransactionDate AS DATE) AS [Date],
        COUNT(*) AS TotalTransactions,
        SUM(Amount) AS TotalAmount
    FROM FactTransaction
    WHERE TransactionDate BETWEEN @start_date AND @end_date
    GROUP BY CAST(TransactionDate AS DATE)
    ORDER BY [Date];
END;

EXEC DailyTransaction 
    @start_date = '2024-01-01', 
    @end_date = '2024-01-31';


-- CREATE STORE PROCEDURES (Balance Per Customer)
CREATE PROCEDURE BalancePerCustomer
    @name NVARCHAR(100) 
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.CustomerName,
        a.AccountType,
        a.Balance,
        a.Balance + 
        ISNULL(SUM(
            CASE 
                WHEN t.TransactionType = 'Deposit' THEN t.Amount
                ELSE -t.Amount
            END
        ), 0) AS CurrentBalance
    FROM DimCustomer c
    JOIN DimAccount a ON c.CustomerID = a.CustomerID
    LEFT JOIN FactTransaction t ON a.AccountID = t.AccountID
    WHERE a.Status = 'active'
      AND c.CustomerName LIKE '%' + @name + '%'
    GROUP BY c.CustomerName, a.AccountType, a.Balance
END;

EXEC BalancePerCustomer @name = 'Shelly';

