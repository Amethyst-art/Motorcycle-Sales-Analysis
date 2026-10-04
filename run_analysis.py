import pandas as pd
import sqlite3

# Loading data into a temporary SQLite database
conn = sqlite3.connect(':memory:')
df = pd.read_csv('data/motorcycle_sales.csv')
df.to_sql('sales', conn, index=False, if_exists='replace')


query = """
SELECT 
    product_line,
    STRFTIME('%m', date) AS month, -- Groups smoothly by month number
    warehouse,
    ROUND(SUM(total - payment_fee), 2) AS net_revenue
FROM sales
WHERE client_type = 'Wholesale'
GROUP BY product_line, STRFTIME('%m', date), warehouse
ORDER BY product_line, STRFTIME('%m', date) ASC, net_revenue DESC;
"""

print("--- GENERATING REVENUE EXPORT ---")

# 3. Pull the query results straight into a DataFrame
report_df = pd.read_sql_query(query, conn)

# 4. Export the data smoothly to your results directory
report_df.to_csv('results/revenue_analysis.csv', index=False)

print("\n=======================================================")
print(" TOP 5 WHOLESALE REVENUE COMBINATIONS")
print("=======================================================")
print(report_df.head(5).to_string(index=False))
print("=======================================================\n")

print("File exported to results/revenue_analysis.csv")
conn.close()
