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
Production Service Desk data can't be shared publicly, so I generated a synthetic dataset (~44k tickets, June 2024–June 2026) mirroring platforms like TOPdesk. I deliberately built in realistic data-quality issues miscategorised tickets, spelling variants, mixed date formats, duplicates, and missing values. plus ground-truth flags (self_service_eligible, automation_suitability) to quantify the automation opportunity. Held in one wide table by design, to practise cleaning a real operational export.

### 2. Data Preparation & EDA
Cleaned and profiled in pandas before loading — done here, not in Power BI, so the logic is transparent and reproducible. Collapsed ~69 subcategory variants to ~43, parsed mixed-format dates, converted handling times to numeric minutes, removed duplicates, and imputed missing handling time from subcategory medians. Reduced 44,250 raw records to 41,927 analysis-ready rows.🧹[Cleaning & EDA](01_python_Data_cleaning_eda/IT_Service_Desk_Data_Cleaning_and_EDA.ipynb)

### 3. Data Analysis
Loaded via SQLAlchemy and indexed for performance. Each business question answered with dedicated queries using aggregation and window functions: call drivers, repetitive workload, hours lost and FTE cost, store ranking, KB coverage, seasonality, and automation opportunity.🔍[Data Analysis](02_sql_analysis/Data_Analysis_SQL.sql)

### 4. Data Modelling & Visualisation
Connected directly to PostgreSQL. Created a date dimension to support correct time-based aggregation and chronological sorting. All KPIs were built as DAX measures (held in a dedicated measures table) so metrics calculate consistently across the report. The result is a single executive page: a KPI strip over six visuals, each answering one business question and paired with a one-line interpretive caption stating the finding 
📊 [View the full dashboard (PDF)](03_powerbi_dashboard/service_desk_dashboard.pdf)

## 📌 Key Findings

**1. Two-thirds of all tickets never needed an analyst.** Evidence: 65.8% of 41,927 tickets (~27,600) were avoidable; only 34.2% genuinely required analyst skill. Impact: The team is spending the majority of its capacity on work a portal could absorb.

**2. Repetitive work consumes ~1.4 full-time analysts.**
Avoidable tickets accounted for 4,759 handling hours over two years, the equivalent of 1.4 full-time analysts tied up on low-complexity requests instead of technical issues.

**3. The problem is adoption, not documentation.**
88% of avoidable tickets already had a Knowledge Base article — yet were still logged with the service desk. The gap is behavioural: stores aren't using existing self-help, not lacking it.

**4. A handful of stores drive disproportionate volume.**
The top ticket-logging stores generated several times the volume of the average site, concentrating avoidable demand and marking clear targets for self-service training.

**5. Demand is highly seasonal.**
Ticket volume peaks every November–December, driven by peak retail trading, with a secondary January rise — meaning automation and staffing should flex to match predictable seasonal load.


## Recommendations
1. **Deploy a self-service password reset flow.** Targets the top ~6,400 tickets. Expected: ~15% total ticket reduction and the fastest payback of any single action.
2. **Launch a deflection chatbot surfacing existing KB articles.** Closes the 88% adoption gap. Expected: capture a meaningful share of the 27,600 avoidable tickets with near-zero content cost.
3. **Automate the top 6 call drivers first.** Expected: recover a large portion of the 4,759 lost hours ≈ ~0.3 FTE, redirected to complex work.
4. **Go live before November.** Expected: absorb the Nov–Dec peak and protect SLAs during highest-risk trading weeks.
5. **Target high-volume stores** (Kendal, Carlisle, Ipswich) for rollout. Expected: concentrate early wins where ticket volume — and ROI — is greatest.
