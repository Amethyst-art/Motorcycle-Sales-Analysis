
# Motorcycle Parts Sales Analysis Using SQL and Python

## Overview
A SQL analysis of simulated wholesale and retail motorcycle-parts orders. It identifies which product lines, warehouses and months drive wholesale **net revenue** (`total − payment_fee`), and validates that the pipeline reproduces the known properties of the data.

## Data
The dataset is **synthetic**. `generate_data.py` creates 1,000 orders (June–August 2026; 200 wholesale, 800 retail) with a fixed random seed (42). It has a column structure of : date, warehouse, client type, product line, quantity, unit price, total, payment method and payment fee. 
NOTE: No DataCamp data is used.

Because the numbers are simulated, the results demonstrate the analysis method, not real business performance. Findings that follow directly from a generator assumption are flagged.

## Project structure
```text
├── generate_data.py      # creates data/motorcycle_sales.csv
├── run_analysis.py       # loads the CSV into SQLite, runs every query
├── sql/analysis.sql      # 7 named queries
├── data/                 # generated dataset
└── results/              # one CSV per query
```

## How to run
```bash
pip install pandas numpy
python generate_data.py
python run_analysis.py
```

## Questions answered
| Query | Question |
|---|---|
| `net_revenue_by_line_month_warehouse` | Wholesale net revenue by product line, month and warehouse |
| `revenue_by_product_line` | Which product lines hold the largest share of net revenue? |
| `revenue_by_warehouse` | Order count and average order value by warehouse |
| `monthly_trend` | Month-over-month growth in net revenue |
| `top_combinations` | Which product line pairs perform best? |
| `payment_fee_impact` | How much do processing fees cost, by payment method? |
| `wholesale_vs_retail` | How do the two client types compare? |

## Validation checks
- **Reconciliation:** gross wholesale revenue $528,302.47 − fees $9,360.99 = $518,941.48. The product line, warehouse and month breakdowns each sum to this same total.
- **Fee rates:** measured fees are 2.9% (credit card), 1.0% (transfer) and 0.0% (cash), matching the rates in the generator.
- **Row counts:** 200 wholesale + 800 retail = 1,000.

## Key findings
1. **Revenue is concentrated in two product lines.** Frame & body (28.5%) and Engine (28.4%) together make up 56.9% of wholesale net revenue. Miscellaneous sells more units than Engine (3,383 vs 2,807) but earns under a third of the revenue, so price tier matters more than volume. *(`revenue_by_product_line`)*
2. **Two product/warehouse pairs generate a third of net revenue.** Frame & body at Central ($98,672, 19.0%) and Engine at West ($74,850, 14.4%) together account for 33.4%, out of 18 possible combinations. *(`top_combinations`)*
3. **Central leads on volume, West on order size.** Central handles 100 of 200 wholesale orders and 45.6% of net revenue. West has the fewest orders (47) but the highest average order value ($3,471 vs $2,410 for Central). With only 47 orders, a handful of large ones can drive this. *(`revenue_by_warehouse`)*
4. **Fees are a small lever.** Fees total 1.8% of gross revenue. Credit cards account for 80.6% of fees while carrying 49.2% of gross revenue. Back-of-envelope: shifting all credit-card orders to transfer would save about $4,900 (≈1% of net revenue). *(`payment_fee_impact`)*
5. **Wholesale dominates revenue by construction.** Wholesale is 20% of orders but 73.4% of net revenue, with an average order about 11x retail ($2,642 vs $239). This follows from the generator's quantity ranges (wholesale 20–150 units, retail 1–15), so it is an assumption, not a discovery. *(`wholesale_vs_retail`)*
6. Net revenue rose each month, but this is not evidence of a trend. Revenue went from $139,538 in June to $178,449 in July (+27.9%) and $200,954 in August (+12.6%). With only three months and about 67 wholesale orders per month, a few large orders can move a monthly total substantially. The generator draws order dates uniformly, so no growth was actually built into the data.

## Limitations
- Synthetic data: patterns reflect generator assumptions, not market behavior.
- Three months of data cannot show seasonality.
- "Net revenue" deducts payment fees only. Without cost data it is not profit.
- Average order value is sensitive to outliers and no statistical testing was done.

## Next steps
- Re-run the pipeline on real transaction data with 12+ months to test for seasonality.
- Add median order value to check the West warehouse result.
- Add product cost data to move from net revenue to margin.
- Add the credit-card-to-transfer fee scenario as its own query.