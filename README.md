# 🛒 E-Commerce Funnel Analysis

A SQL-based sales funnel analysis on real user event data, tracking the full customer journey from page view to purchase across traffic sources.

---

## 📁 Project Structure

```
funnel-analysis/
├── Funnel_Analysis.sql       # Main SQL analysis script
├── user_events.csv           # Source data (9,381 events, Dec 2025 – Feb 2026)
├── Report_Funnel_Analysis.md # Full findings report with insights
└── README.md                 # This file
```

---

## 📊 Dataset Overview

| Field | Value |
|---|---|
| **Period** | Dec 30, 2025 – Feb 3, 2026 (35 days) |
| **Total Events** | 9,381 |
| **Unique Visitors** | 5,000 |
| **Total Revenue** | $87,975 |

**Event types tracked:** `page_view` → `add_to_cart` → `checkout_start` → `payment_info` → `purchase`

**Traffic sources:** Organic, Paid Ads, Email, Social

---

## 🔍 Analysis Sections

| # | Section | Description |
|---|---|---|
| 1 | **Data Validation** | Format checks, date range, data types |
| 2 | **Funnel Stages** | Unique users at each conversion step |
| 3 | **Conversion Rates** | Step-by-step and overall conversion |
| 4 | **Funnel by Source** | Breakdown per traffic channel |
| 5 | **Time to Convert** | Avg minutes from view → cart → purchase |
| 6 | **Revenue Analysis** | AOV, revenue per buyer, revenue per visitor |

---

## 📈 Key Results

- **Overall conversion rate:** 16.5% (view → purchase)
- **Biggest drop-off:** View → Cart (only 31.1% add to cart)
- **Best traffic source:** Email at 33.9% conversion
- **Average order value:** $106.51

---

## 🛠️ How to Run

This script is written for **Microsoft SQL Server** (T-SQL). To run it:

1. Create a database named `AnalysisDB`
2. Import `user_events.csv` into a table `dbo.user_events`
3. Open `Funnel_Analysis.sql` in SSMS or Azure Data Studio
4. Run queries section by section (each is separated by a comment block)

> **Note:** The script uses `TRY_CONVERT(datetime2, ...)` because the `event_date` column is stored as `VARCHAR`. The date filter is anchored to `2026-02-03` (last day of data).

---

## 💡 Insights & Recommendations

See [`Report_Funnel_Analysis.md`](./Report_Funnel_Analysis.md) for the full write-up, including bottleneck identification and actionable recommendations.

---

## 👤 Author

Funnel analysis project — SQL + data analytics portfolio piece.
