# Online-Retail-Sales-Analysis
End-to-end retail analysis: Identifying sales trends and operational risks to optimise business performance, using SQL for data transformation and Tableau for visualisation.

## Project Overview
This project focuses on building a robust analytical framework to answer: 'Why did sales change?' I leveraged SQL to process raw transactional records and built a relationship-driven Tableau dashboard. This project demonstrates the ability to take external raw data and convert it into actionable business intelligence by linking sales, customers, and risks.

## Key Objectives
- Root Cause Analysis: Identify drivers behind sales fluctuations (Customer, Product, Region) in a single view.
- Architectural Balance: Optimize performance with SQL Pre-aggregation while maintaining flexibility with Tableau Dynamic Logic.
- Actionable Insights: Provide decision support for customer retention and operational risk management.

## Tools & Technologies
- SQL (MySQL): Data cleaning, logic segregation, and pre-aggregation.
- Tableau: Relationship modeling, dynamic Top-N logic, and interactive storytelling.
- Dataset: UCI Machine Learning Repository: Online Retail (https://archive.ics.uci.edu/dataset/352/online+retail)

## Analysis Workflow
1. Data Modeling & Assumptions ("The Base Grain")
The Assumption: Treated each row as a Logical Invoice Line to handle the absence of a unique line identifier.
Logic Segregation: Separated 'Sale' vs. 'Cancellation' at the SQL level to ensure clean revenue metrics while enabling independent risk tracking.

2. Business Momentum (SQL Exploration)
Growth Metrics: Developed advanced queries for MoM (Month-over-Month) and QoQ (Quarter-over-Quarter) growth.
Unified Dimension: Integrated a YearMonth key across all tables to bridge the gap between SQL and Tableau’s relationship model.

3. Tableau Optimization & Features
Dynamic Top-N: Used Parameters instead of static filters, allowing "Top Customers" to update in real-time based on the selected period.
Action Filters: Configured global triggers to enable Drill-down analysis—selecting a specific month on the sales trend line automatically filters all related dimensions (Customers, Products, and Countries).

## Key Insights & Business Value
- Peak Performance Period: 매출이 가장 높았던 월. 그 원인(예: 영국 시장의 집중적인 구매, 특정 카테고리의 인기)& 실제수치. 예: "매출이 11월에 전월 대비 30% 급증했으며, 이는 UK 시장의 연말 이벤트성 수요와 기프트 아이템 판매 증가가 주도함."
- Operational Risk:취소율(Cancellation Rate)'이 유독 높은 국가나 상품군. "어느 지역의 취소율이 평균보다 몇% 높아서 운영 개선이 필요해 보인다". 예: "특정 국가의 취소율이 평균 5%를 상회하는 12%로 나타남. 이는 해당 지역의 배송 물류나 통관 프로세스 점검이 필요함을 시사함."
- Customer Concentraion:

## Repository Structure
├── Raw_Data/
│   ├── Online_Retail_Raw.xlsx
│   └── Data_Dictionary.png
├── SQL/
│   ├── 01_Data_Cleaning.sql
│   ├── 02_Data_Exploration.sql
│   └── 03_Tableau_Preparation.sql
├── Tableau/
│   ├── Online_Retail_Analysis.twbx     
│   ├── Tableau_Dashboard_Screenshot.png 
│   ├── MasterFactTable.csv
│   ├── Data_Source_1.csv
│   ├── Data_Source_2.csv
│   └── Data_Source_3.csv
└── README.md                          

## Dashboard Preview
https://public.tableau.com/views/OnlineRetailAnalysisProject_17708374223560/Dashboard1?:language=en-GB&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link
