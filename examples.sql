-- Examples in bean-query for beancount and their translation to PSQL database done with the importer


-- Total fees made by Tino or Tuno per year and account:
SELECT year, account, sum(position) as total  WHERE account ~ 'Expenses:Tino' OR account ~ 'Expenses:Tuno' Group by year,account

-- Translation for PSQL
SELECT EXTRACT(YEAR FROM date) as Year, account, ROUND(SUM(number)::numeric,2) as Total
FROM bean
WHERE account LIKE '%Expenses:Tino%' 
OR account LIKE '%Expenses:Tuno%'
GROUP BY Year, account
ORDER BY Year
--------------------------------------------------------------------------------
-- Total medical fees of Tino where the payee was not the insurance
SELECT year, account, sum(position) as total WHERE account = 'Expenses:Tino:Doctor' and payee != 'INSURANCE'

-- Translation for PSQL
SELECT EXTRACT(YEAR FROM fecha) as YEAR, account, sum(quantity) as total 
FROM bean
WHERE account = 'Expenses:Tino:Doctor' and payee != 'INSURANCE'
GROUP BY YEAR, account
ORDER BY YEAR;


--------------------------------------------------------------------------------
-- Total pay to a clinic from an account per year.
SELECT year, account, sum(position) as Paid_by_me WHERE payee = "Clinic Expensive" and account= "Assets:Account:BoA"

-- Translation for PSQL
SELECT EXTRACT(YEAR FROM date) as Year, account, ROUND(SUM(number)::numeric,2) as "Paid by me"
FROM bean
WHERE payee = 'Clinic Expensive' 
AND account = 'Assets:Account:BoA'
GROUP BY Year, account
ORDER BY Year
