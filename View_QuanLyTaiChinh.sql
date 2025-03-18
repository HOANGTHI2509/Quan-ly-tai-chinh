USE QuanLyTaiChinh
GO
-- View này kết hợp thông tin từ bảng users và accounts để hiển thị tên người dùng, 
-- tên đầy đủ, tên tài khoản, tên ngân hàng, số tài khoản và số dư.
CREATE VIEW UserAccounts AS
SELECT u.user_id, u.username, u.full_name, a.account_name, a.bank_name, a.account_number, a.balance
FROM users u
JOIN accounts a ON u.user_id = a.user_id;
GO
--============================================================================================
-- View giao dịch theo người dùng
-- View này hiển thị các giao dịch của mỗi người dùng, bao gồm ngày giao dịch, 
-- mô tả, số tiền và danh mục.
CREATE VIEW UserTransactions AS
SELECT u.username, t.transaction_date, t.description, t.amount, t.category
FROM users u
JOIN transactions t ON u.user_id = t.user_id;
GO
--============================================================================================
-- View tổng số dư tài khoản theo người dùng
-- View này tính toán tổng số dư của tất cả các tài khoản của mỗi người dùng.
CREATE VIEW UserTotalBalance AS
SELECT u.username, SUM(a.balance) AS total_balance
FROM users u
JOIN accounts a ON u.user_id = a.user_id
GROUP BY u.username;
GO
--============================================================================================
-- View đầu tư theo người dùng
-- View này hiển thị thông tin đầu tư của mỗi người dùng, bao gồm tên đầu tư, 
-- loại đầu tư, số tiền đầu tư ban đầu, giá trị hiện tại và ngày mua.
CREATE VIEW UserInvestments AS
SELECT u.username, i.investment_name, i.investment_type, i.initial_investment, i.current_value, i.purchase_date
FROM users u
JOIN investments i ON u.user_id = i.user_id;
GO
--============================================================================================
-- View ngân sách theo người dùng và danh mục
-- View này hiển thị thông tin ngân sách của mỗi người dùng, bao gồm tháng/năm, 
-- danh mục, số tiền được phân bổ và số tiền đã chi tiêu.
CREATE VIEW UserBudgets AS
SELECT u.username, b.month_year, b.category, b.allocated_amount, b.spent_amount
FROM users u
JOIN budget b ON u.user_id = b.user_id;
GO
--============================================================================================
-- View khoản vay theo người dùng
-- View này hiển thị thông tin khoản vay của mỗi người dùng, bao gồm người cho vay, 
-- số tiền vay, lãi suất, ngày bắt đầu, ngày đáo hạn và trạng thái.
CREATE VIEW UserLoans AS
SELECT u.username, l.lender, l.loan_amount, l.interest_rate, l.start_date, l.due_date, l.status
FROM users u
JOIN loans l ON u.user_id = l.user_id;
GO
--============================================================================================
-- View giao dịch theo tài khoản
-- View này hiển thị các giao dịch của mỗi tài khoản.
CREATE VIEW AccountTransactions AS
SELECT a.account_name, t.transaction_date, t.description, t.amount, t.category
FROM accounts a
JOIN transactions t ON a.account_id = t.account_id;
GO
--============================================================================================
-- View đầu tư sinh lời
-- View này chỉ hiển thị các khoản đầu tư có giá trị hiện tại lớn hơn giá trị đầu tư ban đầu.
CREATE VIEW ProfitableInvestments AS
SELECT u.username, i.investment_name, i.investment_type, i.initial_investment, i.current_value, i.purchase_date
FROM users u
JOIN investments i ON u.user_id = i.user_id
WHERE i.current_value > i.initial_investment;
GO
--============================================================================================
-- View ngân sách còn lại
-- View này tính toán và hiển thị số tiền còn lại trong ngân sách của mỗi người dùng cho từng danh mục.
CREATE VIEW RemainingBudget AS
SELECT u.username, b.month_year, b.category, (b.allocated_amount - b.spent_amount) AS remaining_amount
FROM users u
JOIN budget b ON u.user_id = b.user_id;
GO
--============================================================================================
-- View khoản vay đang hoạt động
-- View này chỉ hiển thị các khoản vay đang trong trạng thái "Active".
CREATE VIEW ActiveLoans AS
SELECT u.username, l.lender, l.loan_amount, l.interest_rate, l.start_date, l.due_date
FROM users u
JOIN loans l ON u.user_id = l.user_id
WHERE l.status = 'Active';
GO
--============================================================================================
-- Các câu lệnh để chạy VIEW
SELECT * FROM UserAccounts;
SELECT * FROM UserTransactions;
SELECT * FROM UserTotalBalance;
SELECT * FROM UserInvestments;
SELECT * FROM UserBudgets;
SELECT * FROM UserLoans;
SELECT * FROM AccountTransactions;
SELECT * FROM ProfitableInvestments;
SELECT * FROM RemainingBudget;
SELECT * FROM ActiveLoans;