--Bước 1:
-- Tạo login cho Quản lý
CREATE LOGIN admin WITH PASSWORD = 'admin_secure_pass123';

-- Tạo login cho Nhân viên
CREATE LOGIN employee WITH PASSWORD = 'employee_pass456';

-- Tạo login cho Khách hàng (ví dụ: user1)
CREATE LOGIN customer1 WITH PASSWORD = 'customer_pass789';
--=====================Tạo users người dùng======================
USE QuanLyTaiChinh;
GO
--==================Bước 2========================
-- Tạo user cho admin
CREATE USER admin FOR LOGIN admin;

-- Tạo user cho employee
CREATE USER employee FOR LOGIN employee;
-- Tạo user cho customer1
CREATE USER customer1 FOR LOGIN customer1;
--=====================Bước 3=================================
--=====================Phân Quyền cho quản lý======================
USE QuanLyTaiChinh;
GO

-- Cấp quyền CONTROL (tương đương toàn quyền) cho admin
GRANT CONTROL ON DATABASE::QuanLyTaiChinh TO admin;
--=====================Phân Quyền cho nhân viên======================
USE QuanLyTaiChinh;
GO

-- Quyền SELECT, INSERT, UPDATE trên các bảng
GRANT SELECT, INSERT, UPDATE ON dbo.users TO employee;
GRANT SELECT, INSERT, UPDATE ON dbo.accounts TO employee;
GRANT SELECT, INSERT, UPDATE ON dbo.transactions TO employee;
GRANT SELECT, INSERT, UPDATE ON dbo.investments TO employee;
GRANT SELECT, INSERT, UPDATE ON dbo.budget TO employee;
GRANT SELECT, INSERT, UPDATE ON dbo.loans TO employee;

-- Quyền SELECT trên các VIEW
GRANT SELECT ON dbo.UserAccounts TO employee;
GRANT SELECT ON dbo.UserTransactions TO employee;
GRANT SELECT ON dbo.UserTotalBalance TO employee;
GRANT SELECT ON dbo.UserInvestments TO employee;
GRANT SELECT ON dbo.UserBudgets TO employee;
GRANT SELECT ON dbo.UserLoans TO employee;
GRANT SELECT ON dbo.AccountTransactions TO employee;
GRANT SELECT ON dbo.ProfitableInvestments TO employee;
GRANT SELECT ON dbo.RemainingBudget TO employee;
GRANT SELECT ON dbo.ActiveLoans TO employee;

-- Quyền EXECUTE trên các stored procedure
GRANT EXECUTE ON dbo.AddUser TO employee;
GRANT EXECUTE ON dbo.AddAccount TO employee;
GRANT EXECUTE ON dbo.AddTransaction TO employee;
GRANT EXECUTE ON dbo.UpdateAccountBalance TO employee;
GRANT EXECUTE ON dbo.AddInvestment TO employee;
GRANT EXECUTE ON dbo.AddBudget TO employee;
GRANT EXECUTE ON dbo.UpdateBudgetSpentAmount TO employee;
GRANT EXECUTE ON dbo.AddLoan TO employee;
GRANT EXECUTE ON dbo.UpdateLoanStatus TO employee;
--=====================Phân Quyền cho tài khoản khách hàng======================
USE QuanLyTaiChinh;
GO

-- Quyền SELECT trên các bảng
GRANT SELECT ON dbo.users TO customer1;
GRANT SELECT ON dbo.accounts TO customer1;
GRANT SELECT ON dbo.transactions TO customer1;
GRANT SELECT ON dbo.investments TO customer1;
GRANT SELECT ON dbo.budget TO customer1;
GRANT SELECT ON dbo.loans TO customer1;

-- Quyền SELECT trên các VIEW
GRANT SELECT ON dbo.UserAccounts TO customer1;
GRANT SELECT ON dbo.UserTransactions TO customer1;
GRANT SELECT ON dbo.UserTotalBalance TO customer1;
GRANT SELECT ON dbo.UserInvestments TO customer1;
GRANT SELECT ON dbo.UserBudgets TO customer1;
GRANT SELECT ON dbo.UserLoans TO customer1;
GRANT SELECT ON dbo.AccountTransactions TO customer1;
GRANT SELECT ON dbo.ProfitableInvestments TO customer1;
GRANT SELECT ON dbo.RemainingBudget TO customer1;
GRANT SELECT ON dbo.ActiveLoans TO customer1;

--Áp dụng Row-Level Security (RLS) để giới hạn dữ liệu của khách hàng:

-- Tạo hàm bảo mật để lọc dữ liệu theo user_id
CREATE FUNCTION dbo.fn_securitypredicate(@user_id AS INT)
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN SELECT 1 AS fn_securitypredicate_result
WHERE @user_id = CAST(SESSION_CONTEXT(N'UserID') AS INT)
   OR USER_NAME() = 'admin' OR USER_NAME() = 'employee';
GO
--bat tat bao mat

ALTER SECURITY POLICY UserFilter WITH (STATE = OFF);
SELECT * FROM users;
GO

-- Tạo chính sách bảo mật (security policy)
CREATE SECURITY POLICY UserFilter
ADD FILTER PREDICATE dbo.fn_securitypredicate(user_id) ON dbo.users,
ADD FILTER PREDICATE dbo.fn_securitypredicate(user_id) ON dbo.accounts,
ADD FILTER PREDICATE dbo.fn_securitypredicate(user_id) ON dbo.transactions,
ADD FILTER PREDICATE dbo.fn_securitypredicate(user_id) ON dbo.investments,
ADD FILTER PREDICATE dbo.fn_securitypredicate(user_id) ON dbo.budget,
ADD FILTER PREDICATE dbo.fn_securitypredicate(user_id) ON dbo.loans
WITH (STATE = ON);
GO

-- Đặt user_id vào SESSION_CONTEXT khi khách hàng đăng nhập (thực hiện trong ứng dụng)
EXEC sp_set_session_context @key = N'UserID', @value = 1; -- Ví dụ cho customer1 với user_id = 1


--============Bước 4: kiểm tra==================
-- Kiểm tra quyền của admin
SELECT * FROM sys.database_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('admin');

-- Kiểm tra quyền của employee
SELECT * FROM sys.database_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('employee');

-- Kiểm tra quyền của customer1
SELECT * FROM sys.database_permissions WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('customer1');





--(RLS bật)
USE QuanLyTaiChinh;
GO
EXEC sp_set_session_context @key = N'UserID', @value = 3;
SELECT * FROM users;
SELECT * FROM accounts;
SELECT * FROM transactions;
SELECT * FROM investments;
SELECT * FROM budget;
SELECT * FROM loans;