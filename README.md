# Olist E-Commerce Analytics: Sales, Logistics & Customer Satisfaction Dashboard

An end-to-end data analyst project — raw multi-table e-commerce data transformed into a validated analytics layer and an interactive 5-page Power BI dashboard, built on Python, PostgreSQL, and DAX.

![Python](https://img.shields.io/badge/Python-pandas-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

## 📑 Table of Contents
- [Project Overview](#-project-overview)
- [Business Problem](#-business-problem)
- [Tech Stack](#️-tech-stack)
- [Data Pipeline](#️-data-pipeline)
- [Data Model](#-data-model)
- [SQL Analysis](#-sql-analysis)
- [Power BI Dashboard](#-power-bi-dashboard)
- [Key Findings](#-key-findings)
- [Statistical Analysis](#-statistical-analysis)
- [Data Quality & Validation](#-data-quality--validation)
- [Project Structure](#-project-structure)
- [How to Run the Project](#-how-to-run-the-project)
- [Author](#-author)

## 📊 Project Overview

This project simulates a real analyst workflow on **Olist**, a Brazilian e-commerce marketplace connecting small sellers to major retail channels: taking raw, messy multi-table order data and turning it into a clean, query-ready model and a stakeholder-ready dashboard.

**Dataset:** [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle) — ~100,000 orders from 2016–2018, across 9 relational CSV files (orders, customers, order items, payments, reviews, products, sellers, geolocation, category translation).

**Pipeline:**
```
Raw CSVs (Kaggle)
      │
      ▼
┌─────────────┐
│   PYTHON    │   Cleaning, validation, feature engineering, statistical analysis
└─────────────┘
      │
      ▼
┌─────────────┐
│  POSTGRESQL │   Star schema model, 40+ business-question queries
└─────────────┘
      │
      ▼
┌─────────────┐
│  POWER BI   │   DAX measures, 5-page interactive dashboard
└─────────────┘
```

## 🎯 Business Problem

Olist's leadership lacks one consolidated view connecting sales, logistics, and customer satisfaction. Specifically:
- Revenue trends across categories, states, and time aren't centralized
- Delivery reliability and its link to customer satisfaction isn't quantified
- It's unclear whether late deliveries are a seller problem or a carrier/logistics problem
- Repeat-purchase behavior and regional performance aren't visible in one place

**Objective:** build a reporting layer (SQL + Power BI) that reveals revenue drivers, delivery performance, and satisfaction together, and surfaces concrete improvement opportunities for Sales, Logistics, and Customer Experience stakeholders.

**Primary stakeholders:** COO, Category/Sales Manager, Logistics Manager, Customer Experience Manager, Finance.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Python (pandas, numpy, scipy) | Data cleaning, validation, feature engineering, statistical testing |
| PostgreSQL | Relational modeling, business-question analysis |
| pgAdmin | Database management |
| Power BI + DAX | Data modeling, measures, dashboard |
| Git & GitHub | Version control and documentation |

## ⚙️ Data Pipeline

| Stage | Description |
|---|---|
| **Raw** | 9 source CSVs, loaded and profiled as-is (row counts, nulls, dtypes, foreign-key mapping) |
| **Cleaned** | Standardized types, documented missing-value handling, deduplicated, derived columns (`order_total`, `delivery_delay_days`, `is_late`) |
| **Modeled (SQL)** | Loaded into a PostgreSQL star schema with enforced PK/FK constraints and indexes |
| **Analyzed (SQL)** | 40+ business questions — beginner → advanced (joins, CTEs, window functions, cohort analysis) |
| **Analyzed (Python)** | Statistical testing — correlation, hypothesis tests, ANOVA, chi-square, confidence intervals |
| **Visualized (Power BI)** | Star schema import, 30+ DAX measures, 5-page validated dashboard |

## ⭐ Data Model

The analytics layer follows a **star schema**: dimension tables for context, fact tables for transactional grain.

```
dim_customers ──┐
dim_products ───┤
dim_sellers ────┼──< fact_orders ──< fact_order_items
dim_date ───────┤         │
                │         ├──< fact_payments
                │         └──< fact_reviews
```

| Dimension Tables | Fact Tables |
|---|---|
| `dim_customers` | `fact_orders` (grain: 1 row / order) |
| `dim_products` | `fact_order_items` (grain: 1 row / item) |
| `dim_sellers` | `fact_payments` (grain: 1 row / payment installment) |
| `dim_date` (generated calendar, 2016–2018) | `fact_reviews` (grain: 1 row / review) |

![Star Schema ERD]
<img width="1168" height="736" alt="Star_scema_erd" src="https://github.com/user-attachments/assets/e5d5327f-68af-4f1e-aa1e-620a1a5fc08e" />



📄 Full column-level details: [`python/data_dictionary.md`](python/data_dictionary.md)

## 🔍 SQL Analysis

40 business questions answered across three tiers:
- **Beginner (10):** `SELECT`, `WHERE`, `ORDER BY`, `CASE WHEN`
- **Intermediate (15):** `GROUP BY`, `HAVING`, `JOIN`, subqueries, CTEs, date functions
- **Advanced (15):** Window functions (`LAG`, `RANK`, `ROW_NUMBER`), running totals, MoM/YoY growth, cohort retention

Plus a bonus analysis: **customer churn rate by state** (single-order customers with no repeat purchase within a 6-month window).

Full queries: [`sql/analysis_queries.sql`](sql/analysis_queries.sql) · Schema: [`sql/schema.sql`](sql/schema.sql) · Load scripts: [`sql/load.sql`](sql/load.sql)

## 📈 Power BI Dashboard

5 pages, each built for a specific stakeholder audience:

| Page | Audience | Answers |
|---|---|---|
| **Executive Overview** | COO, leadership | Is the marketplace healthy right now? |
| **Sales Analysis** | Category/Sales Manager | What's driving revenue growth or decline? |
| **Customer Analysis** | CX/Marketing Manager | Who are the customers, and are they returning? |
| **Logistics & Satisfaction** | Logistics/CX Manager | Is delivery performance hurting satisfaction, and whose problem is it? |
| **Regional Analysis** | COO, Sales leadership | Which regions need investment? |

### Screenshots

**Executive Overview**
<img width="1209" height="744" alt="Page1_Executive_Overview" src="https://github.com/user-attachments/assets/01ee5702-5944-40cc-bb96-077254ff9542" />


**Sales Analysis**
<img width="1172" height="743" alt="Page2_Sales_Analysis" src="https://github.com/user-attachments/assets/3c54d4af-0c13-45bf-9ab3-e9fed82a0295" />


**Customer Analysis**
<img width="1177" height="742" alt="Page3_Customer_Analysis" src="https://github.com/user-attachments/assets/416ad11e-2864-40ae-bb17-2be3c55e7bef" />


**Logistics & Satisfaction**
<img width="1194" height="745" alt="Page4_Logistics_ _Satisfaction" src="https://github.com/user-attachments/assets/fe6fb00e-b9f1-4330-addf-32382987e540" />



**Regional Analysis**
<img width="1197" height="743" alt="Page5_Regional_Analysis" src="https://github.com/user-attachments/assets/d257bd21-24ef-49e2-8fff-37f0e00b04e5" />




Live `.pbix`: [`powerbi/Olist Ecommerce Dashboard.pbix`](powerbi/Olist Ecommerce Dashboard.pbix)

## 💡 Key Findings

- **Total marketplace revenue: R$16.0M** across 99.4K orders (2016–2018), average order value **R$160.25**
- **Revenue growth: +21.2% YoY** (2017→2018). 2016→2017 is excluded from trend analysis — 2016 was a partial launch year, not comparable
- **On-time delivery rate: ~91.9%**, average delivery time **12.5 days**
- **Delivery lateness is primarily a carrier/distance problem, not a seller problem** — seller handling time holds steady at ~2–3 days across nearly every state, while carrier transit time grows sharply for northern/northeastern states (RR, AP, AM). Seller-level follow-up is recommended only for the small set of sellers whose handling time clearly exceeds the 2–3 day norm
- **Repeat customer rate is low (~3%)** — ~96.9% of customers placed only one order. This reflects a real characteristic of the dataset/business model, not a data error
- **São Paulo (SP) generates the highest revenue (R$6.2M)** but shows a below-average review score — flagged as a risk/opportunity area in the Regional Analysis page

## 📐 Statistical Analysis

Beyond descriptive dashboard metrics, six statistical tests were run in Python (`python/02_statistical_analysis.ipynb`) to validate key claims with proper significance and effect-size testing — not just surface-level averages.

| # | Test | Result | Interpretation |
|---|---|---|---|
| 1 | Mean/Median/Std/Percentiles of Order Value | Mean R$160.25, Median R$105.28, Std R$219.13 | Right-skewed distribution — a small number of high-value orders pull the average up; median better represents a "typical" order |
| 2 | Correlation: Delivery Days vs. Review Score | Pearson r = -0.33, Spearman r = -0.23 (p < 0.001) | Moderate, statistically significant negative relationship — slower delivery is associated with lower satisfaction, though not the sole driver |
| 3 | Independent t-test: On-time vs. Late Review Scores | 4.29/5 vs. 2.27/5 (Welch's t-test, p < 0.001; confirmed with Mann-Whitney U) | **Strongest finding in the project** — a large, statistically robust satisfaction gap between on-time and late deliveries |
| 4 | 95% Confidence Interval on Mean Order Value | R$158.88 – R$161.62 | Narrow, reliable interval given the large sample size (n ≈ 98,800) |
| 5 | Chi-Square: Payment Type vs. Review Score Category | χ² = 22.48, p < 0.001, **Cramér's V = 0.01** | Statistically significant but practically negligible — payment method is not a meaningful driver of satisfaction |
| 6 | ANOVA: Review Score Across Top 5 Categories | F = 65.54, p < 0.001 | Real, meaningful spread (~0.25 points) — `health_beauty` (4.15) and `sports_leisure` (4.12) outperform `bed_bath_table` (3.90) and `furniture_decor` (3.93) |

**Why both p-value and effect size matter:** the chi-square and ANOVA results are both statistically significant (p < 0.001), but they tell very different stories — ANOVA's category effect is real and actionable, while the payment-type association, despite being "significant," has a Cramér's V near zero and isn't practically meaningful at this sample size. Reporting effect size alongside significance avoids overstating a result that a large sample size alone can make appear important.

## ✅ Data Quality & Validation

Every stage was cross-checked against the one before it, not trusted in isolation:
- Primary key uniqueness and referential integrity verified after Python cleaning, and again after SQL load
- Python-computed totals reconciled against SQL aggregates before building further analysis on top
- Power BI DAX measures validated against matching SQL queries at a **filtered** slice (category + year), not just the unfiltered grand total
- Time-intelligence DAX (MoM/YoY/moving average) specifically tested at year boundaries and at the start/end of the dataset, where prior-period logic is most likely to break silently

**Notable data quality issues found and handled:**
- `customer_id` is order-scoped, not person-scoped; `customer_unique_id` is the real repeat-customer key
- A small number of duplicate `review_id`s existed in raw data — deduplicated before enforcing a primary key
- Cleaning steps applied to `orders` (dropping cancelled/undelivered rows) weren't initially propagated to child tables, creating orphan foreign keys caught during SQL load — fixed by filtering all child tables to the cleaned parent before loading
- DAX revenue measures must use item-level aggregation (`fact_order_items`), not order-level (`fact_orders[order_total]`), when filtered by category/product/seller — order-level totals over-count revenue for multi-category orders

📄 Reference: [`python/data_dictionary.md`](python/data_dictionary.md)

## 📁 Project Structure

```
olist-ecommerce-analytics/
│
├── sql/
│   ├── schema.sql
│   ├── load.sql
│   └── analysis_queries.sql
│
├── python/
│   ├── 01_data_cleaning.ipynb
│   ├── 02_statistical_analysis.ipynb
│   └── data_dictionary.md
│
├── powerbi/
│   ├── dashboard.pbix
│   └── screenshots/
│       ├── star_schema_erd.png
│       ├── page1_executive_overview.png
│       ├── page2_sales_analysis.png
│       ├── page3_customer_analysis.png
│       ├── page4_logistics_satisfaction.png
│       └── page5_regional_analysis.png
│
├── .gitignore
└── README.md
```

## 🚀 How to Run the Project

**1. Clone the repository**
```bash
git clone https://github.com/Mohamedyunus97/olist-ecommerce-analytics.git
cd olist-ecommerce-analytics
```

**2. Download the dataset**
Raw CSVs aren't included in this repo (available directly on [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)). Download and place into a local `data/raw/` folder.

**3. Run the Python cleaning notebook**
```bash
cd python
jupyter notebook 01_data_cleaning.ipynb
```
Produces cleaned fact/dimension CSVs in `data/processed/`.

**4. Run the statistical analysis notebook**
```bash
jupyter notebook 02_statistical_analysis.ipynb
```

**5. Build the PostgreSQL schema**
```bash
psql -U postgres -d olist_analytics -f sql/schema.sql
```

**6. Load the cleaned data**
```bash
psql -U postgres -d olist_analytics -f sql/load.sql
```

**7. Run the business-question analysis**
```bash
psql -U postgres -d olist_analytics -f sql/analysis_queries.sql
```

**8. Open the dashboard**
Open `powerbi/dashboard.pbix` in Power BI Desktop, connect to your local `olist_analytics` PostgreSQL database, and refresh.

## 👤 Author

**Mohamed Yunus**
Data Analyst | Python · SQL · Power BI

[GitHub](https://github.com/Mohamedyunus97) · [LinkedIn](www.linkedin.com/in/mohamedyunus097)

⭐ If you found this project useful, consider giving it a star!
