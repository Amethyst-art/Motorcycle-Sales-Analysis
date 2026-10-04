import numpy as np
import pandas as pd

rng = np.random.default_rng(42)
n = 1000

lines = {  # product line: (mean unit price, spread)
    "Breaking system": (18, 0.5), "Electrical system": (25, 0.5),
    "Engine": (45, 0.6), "Frame & body": (35, 0.5),
    "Miscellaneous": (12, 0.4), "Suspension & traction": (30, 0.5),
}
fee_rate = {"Cash": 0.0, "Credit card": 0.029, "Transfer": 0.01}

df = pd.DataFrame({
    "date": pd.Timestamp("2026-06-01") + pd.to_timedelta(rng.integers(0, 92, n), unit="D"),
    "warehouse": rng.choice(["North", "Central", "West"], n, p=[0.25, 0.55, 0.20]),
    "client_type": rng.choice(["Retail", "Wholesale"], n, p=[0.8, 0.2]),
    "product_line": rng.choice(list(lines), n),
    "payment": rng.choice(["Cash", "Credit card", "Transfer"], n, p=[0.2, 0.45, 0.35]),
})
df["quantity"] = np.where(df.client_type == "Wholesale",
                          rng.integers(20, 150, n), rng.integers(1, 15, n))
df["unit_price"] = [round(rng.lognormal(np.log(lines[p][0]), lines[p][1]), 2)
                    for p in df.product_line]
df["total"] = (df.quantity * df.unit_price).round(2)
df["payment_fee"] = (df.total * df.payment.map(fee_rate)).round(2)

df = df.sort_values("date")[["date", "warehouse", "client_type", "product_line",
                             "quantity", "unit_price", "total", "payment", "payment_fee"]]
df.to_csv("data/motorcycle_sales.csv", index=False)
print(df.shape)
