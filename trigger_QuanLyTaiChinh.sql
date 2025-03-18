-- Trigger kiểm tra số dư tài khoản trước khi giao dịch
CREATE TRIGGER UpdateBalanceAfterTransaction
ON transactions
AFTER INSERT
AS
BEGIN
    DECLARE @account_id INT, @amount DECIMAL(18,2);

    SELECT @account_id = account_id, @amount = amount FROM inserted;

    UPDATE accounts
    SET balance = balance + @amount
    WHERE account_id = @account_id;
END;
GO

--Lenh chay code
-- Chèn một giao dịch mới để kích hoạt trigger
INSERT INTO transactions (account_id, amount, transaction_date, description, category, user_id)
VALUES (1, 100.00, GETDATE(), 'Deposit', 'Income', 1);

-- Kiểm tra số dư tài khoản sau khi trigger chạy
SELECT * FROM accounts WHERE account_id = 1;
GO
--============================================================================================
-- Trigger kiểm tra ngày mua đầu tư
CREATE TRIGGER CheckInvestmentPurchaseDate
ON investments
AFTER INSERT
AS
BEGIN
    IF (SELECT purchase_date FROM inserted) > GETDATE()
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50002, 'Purchase date cannot be in the future', 1;
    END;
END;
GO
-- Thử chèn một khoản đầu tư với ngày mua hợp lệ
INSERT INTO investments (user_id, investment_name, investment_type, initial_investment, current_value, purchase_date)
VALUES (1, 'Valid Investment', 'Bond', 1000.00, 1000.00, GETDATE());

-- Kiểm tra các khoản đầu tư
SELECT * FROM investments;
GO
--============================================================================================
-- Trigger cập nhật giá trị đầu tư sau khi thay đổi
CREATE TRIGGER UpdateInvestmentValue
ON investments
AFTER UPDATE
AS
BEGIN
    IF UPDATE(current_value)
    BEGIN
        -- Thực hiện các hành động cần thiết khi giá trị đầu tư thay đổi
        PRINT 'Investment value updated';
    END;
END;
GO
--================Lenh chay=======================
-- Cập nhật giá trị một khoản đầu tư để kích hoạt trigger
UPDATE investments
SET current_value = 1100.00
WHERE investment_id = 1; -- Thay 1 bằng ID đầu tư thực tế

-- Xem lại giá trị đầu tư
SELECT * FROM investments WHERE investment_id = 1;
GO
--============================================================================================
-- Trigger cập nhật số tiền đã chi tiêu trong ngân sách
CREATE TRIGGER UpdateBudgetSpentAmountAfterTransaction
ON transactions
AFTER INSERT
AS
BEGIN
    DECLARE @budget_id INT, @amount DECIMAL(18,2);

    -- Giả sử có một bảng liên kết giữa giao dịch và ngân sách
    -- Bạn cần điều chỉnh truy vấn này dựa trên cấu trúc bảng của mình
    SELECT @budget_id = budget_id, @amount = amount
    FROM inserted i
    JOIN budget_transactions bt ON i.transaction_id = bt.transaction_id;

    UPDATE budget
    SET spent_amount = spent_amount + @amount
    WHERE budget_id = @budget_id;
END;
GO
--============================================================================================
-- Trigger kiểm tra trạng thái khoản vay
CREATE TRIGGER CheckLoanStatus
ON loans
AFTER UPDATE
AS
BEGIN
    IF UPDATE(status)
    BEGIN
        IF (SELECT status FROM inserted) = 'Paid' AND (SELECT status FROM deleted) <> 'Active'
        BEGIN
            ROLLBACK TRANSACTION;
            THROW 50004, 'Loan status cannot be changed to Paid from a non-Active status', 1;
        END;
    END;
END;
GO
--============================================================================================
-- Trigger cập nhật ngày đáo hạn khoản vay
CREATE TRIGGER UpdateLoanDueDate
ON loans
AFTER UPDATE
AS
BEGIN
    IF UPDATE(start_date)
    BEGIN
        UPDATE loans
        SET due_date = DATEADD(year, 1, start_date)
        WHERE loan_id IN (SELECT loan_id FROM inserted);
    END;
END;
GO
--============================================================================================
-- Trigger log giao dịch
CREATE TRIGGER LogTransaction
ON transactions
AFTER INSERT
AS
BEGIN
    -- Tạo một bảng log để lưu trữ thông tin giao dịch
    -- Bạn cần tạo bảng log này trước khi sử dụng trigger
    INSERT INTO transaction_logs (transaction_id, user_id, transaction_date, description, amount, category, account_id, created_at)
    SELECT transaction_id, user_id, transaction_date, description, amount, category, account_id, GETDATE()
    FROM inserted;
END;
GO
--============================================================================================
-- Trigger xóa người dùng và các dữ liệu liên quan (INSTEAD OF)
CREATE TRIGGER DeleteUserCascade
ON users
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM accounts WHERE user_id IN (SELECT user_id FROM deleted);
    DELETE FROM transactions WHERE user_id IN (SELECT user_id FROM deleted);
    DELETE FROM investments WHERE user_id IN (SELECT user_id FROM deleted);
    DELETE FROM budget WHERE user_id IN (SELECT user_id FROM deleted);
    DELETE FROM loans WHERE user_id IN (SELECT user_id FROM deleted);
    DELETE FROM users WHERE user_id IN (SELECT user_id FROM deleted);
END;
GO
--============================================================================================
-- Trigger kiểm tra số dư trước khi giao dịch (AFTER)
CREATE TRIGGER CheckBalanceBeforeTransaction
ON transactions
AFTER INSERT
AS
BEGIN
    DECLARE @account_id INT, @amount DECIMAL(18,2), @balance DECIMAL(18,2);

    SELECT @account_id = account_id, @amount = amount FROM inserted;

    SELECT @balance = balance FROM accounts WHERE account_id = @account_id;

    IF @balance - @amount < 0 AND @amount < 0 -- Chỉ kiểm tra khi rút tiền
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'Insufficient balance', 1;
    END;
END;
GO
--============================================================================================
-- Trigger kiểm tra ngân sách trước khi chi tiêu (AFTER)
CREATE TRIGGER CheckBudgetBeforeSpending
ON transactions
AFTER INSERT
AS
BEGIN
    DECLARE @budget_id INT, @amount DECIMAL(18,2), @spent_amount DECIMAL(18,2), @allocated_amount DECIMAL(18,2);

    -- Giả sử có một bảng liên kết giữa giao dịch và ngân sách
    -- Bạn cần điều chỉnh truy vấn này dựa trên cấu trúc bảng của mình
    SELECT @budget_id = budget_id, @amount = amount
    FROM inserted i
    JOIN budget_transactions bt ON i.transaction_id = bt.transaction_id;

    SELECT @spent_amount = spent_amount, @allocated_amount = allocated_amount
    FROM budget
    WHERE budget_id = @budget_id;

    IF @spent_amount + @amount > @allocated_amount
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50003, 'Budget exceeded', 1;
    END;
END;
GO
