-- Thủ tục thêm người dùng mới
CREATE PROCEDURE AddUser
    @username NVARCHAR(100),
    @password NVARCHAR(255),
    @email NVARCHAR(255),
    @full_name NVARCHAR(255),
    @date_of_birth DATE
AS
BEGIN
    INSERT INTO users (username, password, email, full_name, date_of_birth)
    VALUES (@username, @password, @email, @full_name, @date_of_birth);
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC AddUser 'newuser8', 'password2', 'newuser@exmple.com', 'New User1', '1990-01-01';
GO
--============================================================================================
-- Thủ tục thêm tài khoản mới
CREATE PROCEDURE AddAccount
    @user_id INT,
    @account_name NVARCHAR(255),
    @bank_name NVARCHAR(255),
    @account_number NVARCHAR(50),
    @balance DECIMAL(18,2)
AS
BEGIN
    INSERT INTO accounts (user_id, account_name, bank_name, account_number, balance)
    VALUES (@user_id, @account_name, @bank_name, @account_number, @balance);
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC AddAccount 1, 'New Account', 'New Bank', '1234567891', 1000000;
GO
--============================================================================================
-- Thủ tục thêm giao dịch mới
CREATE PROCEDURE AddTransaction
    @user_id INT,
    @transaction_date DATE,
    @description NVARCHAR(500),
    @amount DECIMAL(18,2),
    @category NVARCHAR(100),
    @account_id INT
AS
BEGIN
    INSERT INTO transactions (user_id, transaction_date, description, amount, category, account_id)
    VALUES (@user_id, @transaction_date, @description, @amount, @category, @account_id);
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC AddTransaction 1, '2023-11-01', 'New Transaction', 500000, 'Other', 1;
GO
--============================================================================================
-- Thủ tục cập nhật số dư tài khoản
CREATE PROCEDURE UpdateAccountBalance
    @account_id INT,
    @amount DECIMAL(18,2)
AS
BEGIN
    UPDATE accounts
    SET balance = balance + @amount
    WHERE account_id = @account_id;
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC UpdateAccountBalance 1, 200000;
GO
--============================================================================================
-- Thủ tục thêm đầu tư mới
CREATE PROCEDURE AddInvestment
    @user_id INT,
    @investment_name NVARCHAR(255),
    @investment_type NVARCHAR(100),
    @initial_investment DECIMAL(18,2),
    @current_value DECIMAL(18,2),
    @purchase_date DATE
AS
BEGIN
    INSERT INTO investments (user_id, investment_name, investment_type, initial_investment, current_value, purchase_date)
    VALUES (@user_id, @investment_name, @investment_type, @initial_investment, @current_value, @purchase_date);
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC AddInvestment 1, 'New Investment', 'Stocks', 1000000, 1200000, '2023-11-01';
GO
--============================================================================================
-- Thủ tục thêm ngân sách mới
CREATE PROCEDURE AddBudget
    @user_id INT,
    @month_year DATE,
    @category NVARCHAR(100),
    @allocated_amount DECIMAL(18,2)
AS
BEGIN
    INSERT INTO budget (user_id, month_year, category, allocated_amount)
    VALUES (@user_id, @month_year, @category, @allocated_amount);
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC AddBudget 1, '2023-11-01', 'Food', 2000000;
GO
--============================================================================================
-- Thủ tục cập nhật số tiền đã chi tiêu trong ngân sách
CREATE PROCEDURE UpdateBudgetSpentAmount
    @budget_id INT,
    @amount DECIMAL(18,2)
AS
BEGIN
    UPDATE budget
    SET spent_amount = spent_amount + @amount
    WHERE budget_id = @budget_id;
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC UpdateBudgetSpentAmount 1, 500000;
GO
--============================================================================================
-- Thủ tục thêm khoản vay mới
CREATE PROCEDURE AddLoan
    @user_id INT,
    @lender NVARCHAR(255),
    @loan_amount DECIMAL(18,2),
    @interest_rate DECIMAL(5,2),
    @start_date DATE,
    @due_date DATE,
    @status NVARCHAR(50)
AS
BEGIN
    INSERT INTO loans (user_id, lender, loan_amount, interest_rate, start_date, due_date, status)
    VALUES (@user_id, @lender, @loan_amount, @interest_rate, @start_date, @due_date, @status);
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC AddLoan 1, 'New Lender', 10000000, 5.0, '2023-11-01', '2024-11-01', 'Active';
GO
--============================================================================================
-- Thủ tục cập nhật trạng thái khoản vay
CREATE PROCEDURE UpdateLoanStatus
    @loan_id INT,
    @status NVARCHAR(50)
AS
BEGIN
    UPDATE loans
    SET status = @status
    WHERE loan_id = @loan_id;
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC UpdateLoanStatus 1, 'Paid';
GO
--============================================================================================
-- Thủ tục xóa người dùng
CREATE PROCEDURE DeleteUser
    @user_id INT
AS
BEGIN
    DELETE FROM users WHERE user_id = @user_id;
END;
GO
-- Lệnh chạy các câu lệnh này.
EXEC DeleteUser 1;
GO
--============================================================================================