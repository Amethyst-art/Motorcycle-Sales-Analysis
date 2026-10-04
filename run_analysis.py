import re
import sqlite3
from pathlib import Path

import pandas as pd

conn = sqlite3.connect(":memory:")
pd.read_csv("data/motorcycle_sales.csv").to_sql("sales", conn, index=False)

sql_text = Path("sql/analysis.sql").read_text()
parts = re.split(r"^-- name:\s*(\w+)\s*$", sql_text, flags=re.M)

Path("results").mkdir(exist_ok=True)
for name, query in zip(parts[1::2], parts[2::2]):
    df = pd.read_sql_query(query, conn)
    df.to_csv(f"results/{name}.csv", index=False)
    print(f"\n=== {name} ===")
    print(df.head(10).to_string(index=False))

conn.close()