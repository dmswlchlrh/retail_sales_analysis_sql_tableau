# Online-Retail-Sales-Analysis
**End-to-end retail analysis**: Identifying sales trends and operational risks to optimise business performance, using SQL for data transformation and Tableau for visualisation.

This project focuses on building a robust analytical framework to answer: **'Why did sales change?'** I leveraged SQL to process raw transactional records and built a relationship-driven Tableau dashboard. This project demonstrates the ability to take external raw data and convert it into actionable business intelligence by linking sales, customers, and risks.


## Key Questions
- What are the overall patterns in **sales growth (MoM/QoQ)**, and are there any significant fluctuations over time?
- How is revenue **distributed across different countries**, and which regions show the most activity?
- What does the **cancellation rate** look like, and are there specific months or regions where it is particulary high?
- Which products and customers are the **primary contributors** to total revenue, and what are their typical purchasing patterns?


## Tech Stack
- **SQL (MySQL)**: Data cleaning, logic segregation, and pre-aggregation.
- **Tableau**: Relationship modeling, dynamic Top-N logic, and interactive storytelling.
- **Dataset**: UCI Machine Learning Repository: Online Retail (https://archive.ics.uci.edu/dataset/352/online+retail)


## Data Processing Flow

**1. Data Cleaning**
- **Handling Anomalies**: Identified and handled missing CustomerID and negative Quantity values representing stock adjustments.
- **Logic Segregation**: Separated 'Sale' vs. 'Cancellation' at the SQL level to ensure clean revenue metrics while enabling independent risk tracking.

**2. Business Momentum (SQL Exploration)**
- **Growth Metrics**: Developed advanced queries for MoM (Month-over-Month) and QoQ (Quarter-over-Quarter) growth.
- **Unified Dimension**: Integrated a YearMonth key across all tables to synchronise SQL pre-aggregations with Tableau’s relationship model.

**3. Tableau Optimisation & Features**
- **Dynamic Top-N**: Used Parameters instead of static filters, allowing "Top Customers" to update in real-time based on the selected period.
- **Action Filters**: Configured global triggers to enable Drill-down analysis—selecting a specific month on the sales trend line automatically filters all related dimensions (Customers, Products, and Countries).


## Key Insights & Business Value

1. Sales peak significantly in October, with notable spikes in March and September, indicating strong seasonal demand in early spring and autumn.
- **Value**: Enables optimised procurement cycles to prevent stockouts during peak periods and balances inventory levels to reduce carrying costs during slower months.

2. The United Kingdom represents over 90% of total revenue. However, secondary growth is visible in European countries like the Netherlands, Ireland, Germany, and France.
- **Value**: Maximises Marketing ROI by focusing spend on the high-performing UK market while providing a data-driven roadmap for global expansion in identified growth regions. 

3. The average cancellation rate is 18.4%, with significant variance across different regions and customer segments.
- **Value**: Protects Net Revenue and reduces operational waste by identifying logistical bottlenecks and stock-out triggers.

4. High-volume 'Best Sellers' -led by 'Rabbit Night Light' and 'Paper Chain Kit'- drive the majority of transaction turnover. Meanwhile, certain specialised items contribute higher profit margins despite lower sales frequency.
- **Value**: This allows for ABC Inventory Analysis, prioritising high-value stock. Furthermore, implementing Product Bundling strategies (pairing high-volume items with slow-moving stock) can increase the Average Order Value (AOV) and improve inventory turnover rates.

5. The Top 10 customers account for a disproportionate share of revenue through bulk orders.
- **Value**: Establishing dedicated loyalty programs or volume-based discount tiers for these key accounts ensures long-term retention and a stable, recurring revenue base.


## Dashboard Preview
[![Tableau Dashboard](Tableau/tableau_dashboard_screenshot.png)](https://public.tableau.com/views/OnlineRetailAnalysisProject_17708374223560/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)


## Dashboard Key Features
**1. Executive Summary (KPIs)**: Provides an immediate snapshot of Total Sales, Total Customers, and the Average Cancellation Rate.

**2. Monthly Sales Trend**: A bar chart visualising revenue from Dec 2010 to Nov 2011, highlighting significant performance peak in October 2011, followed by strong sales momentum in March and September.

**3. Customer & Product Insights**:
- **Top Customers**: Identifies high-value customers. Users can adjust the ranking range using the Top N Parameter at the top right.
- **Best Sellers**: A Treemap visualisation that clarifies which product categories contribute most to the total revenue.

**4. Operational Risk Analysis**:
- **Regional Risk (Map)**: A geographical view to identify sales distribution and potential risk clusters across different countries.
- **Product Cancellation (Heatmap)**: A heatmap tracking cancellations by product and month to identify recurring operational bottlenecks or problematic items.
- **Purchase Behaviour (Scatter Plot)**: Analyses the correlation between total sales and purchase count to distinguish high-value customers.

## Project Structure
```
├── Rawdata/
│   ├── Data_Dictionary.png
│   └── Online_Retail_Raw.xlsx
│ 
├── SQL/
│   ├── 01_Data_Cleaning.sql
│   ├── 02_Data_Exploration.sql
│   └── 03_Tableau_Preparation.sql
│ 
├── Tableau/
│   ├── MasterFactTable.csv
│   ├── Online_Retail_Analysis_Project.twbx 
│   └── Tableau_Dashboard_Screenshot.png
│ 
└── README.md                          
```
