--Khoi tao co so du lieu Quan Ly Tai Chinh
CREATE DATABASE QuanLyTaiChinh;
GO
USE QuanLyTaiChinh;
--Tao bang Users 
CREATE TABLE users (
    user_id INT IDENTITY(1,1) PRIMARY KEY, -- khoa chinh
    username NVARCHAR(100) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    full_name NVARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL
);
GO
--Tao bang accounts
CREATE TABLE accounts (
    account_id INT IDENTITY(1,1) PRIMARY KEY, -- khoa chinh
    user_id INT NOT NULL,
    account_name NVARCHAR(255) NOT NULL,
    bank_name NVARCHAR(255) NOT NULL,
    account_number NVARCHAR(50) NOT NULL UNIQUE,
    balance DECIMAL(18,2) NOT NULL DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO
-- Tao bang transactions
CREATE TABLE transactions (
    transaction_id INT IDENTITY(1,1) PRIMARY KEY, -- Khoa chinh
    user_id INT NOT NULL,
    transaction_date DATE NOT NULL,
    description NVARCHAR(500),
    amount DECIMAL(18,2) NOT NULL,
    category NVARCHAR(100) NOT NULL,
    account_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);
GO
-- Tao bang investments
CREATE TABLE investments (
    investment_id INT IDENTITY(1,1) PRIMARY KEY, -- khoa chinh
    user_id INT NOT NULL,
    investment_name NVARCHAR(255) NOT NULL,
    investment_type NVARCHAR(100) NOT NULL,
    initial_investment DECIMAL(18,2) NOT NULL,
    current_value DECIMAL(18,2) NOT NULL,
    purchase_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO
-- tao bang budget
CREATE TABLE budget (
    budget_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    month_year DATE NOT NULL,
    category NVARCHAR(100) NOT NULL,
    allocated_amount DECIMAL(18,2) NOT NULL,
    spent_amount DECIMAL(18,2) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO
-- tao bang Loans
CREATE TABLE loans (
    loan_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    lender NVARCHAR(255) NOT NULL,
    loan_amount DECIMAL(18,2) NOT NULL,
    interest_rate DECIMAL(5,2) NOT NULL,
    start_date DATE NOT NULL,
    due_date DATE NOT NULL,
    status NVARCHAR(50) CHECK (status IN ('Active', 'Paid', 'Defaulted')),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO
-- cac cau lenh kiem tra bang
SELECT * FROM users;  -- nguoi dung
SELECT * FROM accounts;-- tai khoan
SELECT * FROM transactions; -- giao dich
SELECT * FROM investments; -- dau tu
SELECT * FROM budget; -- ngan sach
SELECT * FROM loans; -- khoan vay
USE QuanLyTaiChinh;
GO

-- Kiểm tra lại
SELECT * FROM users;


-- Xem người dùng hiện tại
SELECT USER_NAME() AS CurrentUser;

-- Xem quyền của người dùng hiện tại
SELECT * FROM sys.database_permissions 
WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID(USER_NAME());



-============================================
USE QuanLyTaiChinh;
GO
--Kiem tra số lượng có trong
SELECT COUNT(*) AS user_count FROM users;
SELECT COUNT(*) AS account_count FROM accounts;
SELECT COUNT(*) AS transaction_count FROM transactions;
SELECT COUNT(*) AS investment_count FROM investments;
SELECT COUNT(*) AS budget_count FROM budget;
SELECT COUNT(*) AS loan_count FROM loans;



