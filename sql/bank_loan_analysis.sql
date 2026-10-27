-- Bank Loan Analysis - SQL queries
-- I imported financial_loan.csv into MySQL as a table called bank_loan_data
-- (using the Table Data Import Wizard) and used these queries to cross-check
-- the numbers on my Excel dashboard.


-- 1. How many loan applications do we have in total?
SELECT COUNT(id) AS total_applications
FROM bank_loan_data;


-- 2. How much money did the bank lend out, and how much came back?
SELECT
    SUM(loan_amount)   AS total_funded,
    SUM(total_payment) AS total_received
FROM bank_loan_data;


-- 3. Average interest rate and average DTI across all loans
SELECT
    ROUND(AVG(int_rate) * 100, 2) AS avg_interest_rate,
    ROUND(AVG(dti) * 100, 2)      AS avg_dti
FROM bank_loan_data;


-- 4. Good loans vs bad loans
-- Fully Paid and Current count as good, Charged Off counts as bad
SELECT
    CASE WHEN loan_status = 'Charged Off' THEN 'Bad Loan' ELSE 'Good Loan' END AS loan_type,
    COUNT(id)          AS applications,
    SUM(loan_amount)   AS funded,
    SUM(total_payment) AS received
FROM bank_loan_data
GROUP BY loan_type;


-- 5. What percentage of loans went bad?
SELECT
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(id), 2)
        AS bad_loan_pct
FROM bank_loan_data;


-- 6. Breakdown by loan status, along with the average interest rate for each
SELECT
    loan_status,
    COUNT(id)                     AS applications,
    SUM(loan_amount)              AS funded,
    SUM(total_payment)            AS received,
    ROUND(AVG(int_rate) * 100, 2) AS avg_interest_rate
FROM bank_loan_data
GROUP BY loan_status;


-- 7. Applications month by month, to see how the portfolio grew over the year
SELECT
    MONTH(issue_date)     AS month_no,
    MONTHNAME(issue_date) AS month_name,
    COUNT(id)             AS applications,
    SUM(loan_amount)      AS funded
FROM bank_loan_data
GROUP BY MONTH(issue_date), MONTHNAME(issue_date)
ORDER BY month_no;


-- 8. What are people borrowing for? (most common purpose first)
SELECT
    purpose,
    COUNT(id)        AS applications,
    SUM(loan_amount) AS funded
FROM bank_loan_data
GROUP BY purpose
ORDER BY applications DESC;


-- 9. Do 60-month loans go bad more often than 36-month loans?
SELECT
    term,
    COUNT(id) AS applications,
    ROUND(SUM(CASE WHEN loan_status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(id), 2)
        AS bad_loan_pct
FROM bank_loan_data
GROUP BY term;


-- 10. Top 10 states by number of applications
SELECT
    address_state,
    COUNT(id)        AS applications,
    SUM(loan_amount) AS funded
FROM bank_loan_data
GROUP BY address_state
ORDER BY applications DESC
LIMIT 10;
