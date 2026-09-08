# E-Commerce Business Analytics Project

End-to-end business analytics project using the **Olist Brazilian E-Commerce Dataset**, covering data cleaning, exploratory analysis, SQL querying, and dashboard building — using **Python, SQL (MySQL), Excel, and Power BI**.

## 🎯 Business Problem

An e-commerce platform wants to understand:
1. How is revenue trending over time?
2. Which product categories and regions drive the most revenue?
3. Does delivery speed affect customer satisfaction?
4. Who are our most valuable customers, and who is at risk of churning?

This project answers these questions using real transactional data (~100K orders, 2016–2018).

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| **Python** (Pandas, Matplotlib) | Data cleaning, exploratory analysis, RFM modeling |
| **SQL** (MySQL) | Business queries using joins, subqueries, CTEs, window functions |
| **Excel / LibreOffice Calc** | Pivot Table + Chart for quick reporting |
| **Power BI** | Interactive 3-page dashboard |

## 📊 Dataset

**Source:** [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle)

8 relational tables covering orders, order items, customers, products, payments, reviews, and sellers — ~99,441 orders from Sept 2016 to Oct 2018.

## 🔍 Key Insights

### 1. Revenue Trend
- Steady month-over-month growth from ~₹138K (Jan 2017) to a peak of **~₹1.6M (Nov 2017)**, then stabilized around ₹1M–1.16M/month through mid-2018.
- Early (Sep–Dec 2016) and final (Sep–Oct 2018) months were excluded from trend analysis due to incomplete data at the dataset's start/end.

### 2. Top Product Categories
- **Health & Beauty**, **Watches & Gifts**, and **Bed/Bath/Table** are the top 3 categories by revenue.
- The **top 10 categories account for ~63% of total revenue**, while the remaining ~63 categories share the rest — indicating a healthy, diversified product mix without over-reliance on a single category.

### 3. Revenue by Region
- **São Paulo (SP) alone drives ~37% of total revenue** — more than double the next state (Rio de Janeiro, ~13%).
- The top 3 states (SP, RJ, MG — the "Southeast" region) account for **~63% of total revenue**, highlighting a strong geographic concentration and a potential opportunity to grow underrepresented regions.

### 4. Delivery Time vs. Customer Satisfaction
- Delivery time shows a **moderate negative correlation (-0.30)** with review scores.
- Average review score by delivery speed:

| Delivery Time | Avg. Review Score |
|---|---|
| 0–7 days | 4.32 ⭐ |
| 8–14 days | 4.19 ⭐ |
| 15–21 days | 4.02 ⭐ |
| 22+ days | **2.98 ⭐** |

- Customer satisfaction is fairly stable up to ~3 weeks, but **collapses sharply beyond 21 days** — suggesting a critical threshold where delayed delivery becomes a major experience failure, rather than a linear decline.

### 5. Customer Segmentation (RFM Analysis)
Customers were segmented using Recency, Frequency, and Monetary scoring:

| Segment | Customers | % of Total |
|---|---|---|
| Potential Loyalists | 48,251 | 50.2% |
| Loyal Customers | 23,477 | 24.4% |
| At Risk | 19,367 | 20.2% |
| Lost | 4,006 | 4.2% |
| Champions | 995 | 1.0% |

- **Only 1% of customers qualify as "Champions"**, while **75%+ of all customers have placed only a single order** — showing a major opportunity to improve retention and repeat-purchase rates through targeted campaigns.

## 📁 Project Structure

```
E-CommerceProject/
├── data/                          # Raw Olist CSV files
├── notebooks/
│   └── ecommerce_analysis.ipynb   # Python cleaning, EDA, RFM analysis
├── sql/
│   └── queries.sql                # All 5 business questions in SQL
├── powerbi/
│   └── ecommerce_analytics_dashboard.pbix
├── excel/
│   └── monthly_revenue_pivot.png
└── README.md
```

## 📈 Dashboard Preview

**Page 1 — Sales Overview:** Monthly revenue trend, top product categories, revenue by state
**Page 2 — Customer Analysis:** RFM-based customer segmentation
**Page 3 — Delivery & Satisfaction:** Review scores vs. delivery time, order volume by delivery speed

## 🧠 Methodology

1. **Data Cleaning (Python)** — handled nulls in delivery dates (expected, orders not yet delivered), missing product categories (labeled "unknown"), and verified zero duplicate records across all 8 tables.
2. **Exploratory Analysis (Python)** — merged all tables into a unified transaction-level dataset (~118K rows) and answered all 5 business questions using Pandas.
3. **SQL Validation** — loaded cleaned data into MySQL and independently recreated every analysis using joins, subqueries, CTEs, and window functions (`NTILE`, `DATEDIFF`, `CASE WHEN`) — results matched Python output within rounding differences.
4. **Excel Reporting** — built a Pivot Table + Chart for a quick, non-technical stakeholder view.
5. **Power BI Dashboard** — built a 3-page interactive dashboard with slicers for filtering by state.

## 🚀 How to Reproduce

1. Download the [Olist dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) and place CSVs in `data/`
2. Run `notebooks/ecommerce_analysis.ipynb` to clean data and generate summary CSVs
3. Load data into MySQL and run queries from `sql/queries.sql`
4. Open `powerbi/ecommerce_analytics_dashboard.pbix` in Power BI Desktop to view/edit the dashboard

## 👤 Author

*[Yukt kumar]*
*[[LinkedIn](https://www.linkedin.com/in/yukt-kumar-7934a528b/)] · [yuktkumar7@gmail.com] 

---
*This project was built as part of my transition into a Data Analyst role, demonstrating end-to-end analytics skills across Python, SQL, Excel, and Power BI.*
