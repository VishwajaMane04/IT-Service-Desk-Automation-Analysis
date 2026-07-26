# IT-Service-Desk-Automation-Analysis
#### End-to-end data analytics project using Python, PostgreSQL and Power BI to identify automation opportunities within an IT Service Desk and estimate the operational impact of self-service and chatbot adoption.

## Executive Summary

The IT Service Desk supports hundreds of retail stores by resolving technical issues such as password resets, printer faults, software access requests, and hardware incidents.

Analysis of 41,927 historical service desk tickets revealed that a significant proportion of requests were repetitive, low-complexity issues that followed standard resolution procedures. These requests consumed thousands of analyst hours each year, reducing the team's ability to focus on higher-value technical work.

This project combines Python, PostgreSQL, and Power BI to identify automation opportunities and provide leadership with data-driven recommendations for reducing Service Desk workload.

## Business Problem

#### - How can the IT Service Desk reduce repetitive work while maintaining service quality?

The Service Desk receives thousands of support requests every year from retail stores across the business. While many incidents require technical expertise, a large proportion involve routine tasks such as password resets, account unlocks, printer issues, and software access requests.

Although these requests are relatively simple to resolve, they consume a significant amount of analyst time, limiting the team's ability to focus on complex incidents and reducing overall operational efficiency.

Leadership believes many of these requests could be resolved through self-service, chatbots, or automated workflows but lacks the evidence to determine where automation would have the greatest impact.

## Business Questions

This project answers the questions that Service Desk leadership needs before investing in automation.

- Which categories generate the highest number of support tickets?
- Which repetitive requests consume the most analyst time?
- How many analyst hours are spent resolving repetitive tickets?
- Which stores generate the highest support demand?
- Are there seasonal peaks in ticket volume?
- Does a Knowledge Base already exist for these issues?
- Which requests are suitable for self-service or chatbot automation?
- What operational impact could automation have on Service Desk workload?

## The Data
- Source: Synthetic dataset modelled on a real retail IT Service Desk ticketing system, generated to mirror realistic ticket structure, category mix, and seasonal demand, no confidential or customer data used.
- Time span: Jun 2024 – Jun 2026 (24 months)

## Project Workflow
Rather than focusing on individual tools, this project demonstrates a complete analytics pipeline.
<img width="1024" height="279" alt="Project workflow" src="https://github.com/user-attachments/assets/4371c481-cc2b-4913-ad9a-e8e3f40d8f4c" />
## Methodology

### 1. Data Generation
Production Service Desk data can't be shared publicly, so I generated a synthetic dataset (~44k tickets, June 2024–June 2026) mirroring platforms like TOPdesk. I deliberately built in realistic data-quality issues — miscategorised tickets, spelling variants, mixed date formats, duplicates, and missing values — plus ground-truth flags (self_service_eligible, automation_suitability) to quantify the automation opportunity. Held in one wide table by design, to practise cleaning a real operational export.

### 2. Data Preparation & EDA
Cleaned and profiled in pandas before loading — done here, not in Power BI, so the logic is transparent and reproducible. Collapsed ~69 subcategory variants to ~43, parsed mixed-format dates, converted handling times to numeric minutes, removed duplicates, and imputed missing handling time from subcategory medians. Reduced 44,250 raw records to 41,927 analysis-ready rows.[Cleaning & EDA](01_python_Data_cleaning_eda/IT_Service_Desk_Data_Cleaning_and_EDA.ipynb)

### 3. Data Analysis
Loaded via SQLAlchemy and indexed for performance. Each business question answered with dedicated queries using aggregation and window functions: call drivers, repetitive workload, hours lost and FTE cost, store ranking, KB coverage, seasonality, and automation opportunity. [Data Analysis](02_sql_analysis/Data_Analysis_SQL.sql)

### 4. Data Modelling & Visualisation
Connected directly to PostgreSQL. Created a date dimension to support correct time-based aggregation and chronological sorting. All KPIs were built as DAX measures (held in a dedicated measures table) so metrics calculate consistently across the report. The result is a single executive page: a KPI strip over six visuals, each answering one business question and paired with a one-line interpretive caption stating the finding 
[Report](03_powerbi_dashboard/Service desk data analysis dashboard.pdf)
