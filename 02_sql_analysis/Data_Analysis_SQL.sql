Select * 
from service_desk_tickets

--Q1 — Highest call drivers

SELECT category, COUNT(*) AS tickets,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM service_desk_tickets
GROUP BY category
ORDER BY tickets DESC;

SELECT subcategory, COUNT(*) AS tickets,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM service_desk_tickets
GROUP BY subcategory
ORDER BY tickets DESC
LIMIT 15;


--Q2 — Repetitive tickets

SELECT self_service_eligible,
       COUNT(*) AS tickets,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct,
   	   ROUND((SUM(handling_minutes) / 60.0)::numeric, 0) AS total_hours
FROM service_desk_tickets
GROUP BY self_service_eligible;

-- Q3 — Hours lost + FTE
SELECT COUNT(*) AS repetitive_tickets,
       ROUND((SUM(handling_minutes) / 60.0)::numeric, 0) AS total_hours,
       ROUND(AVG(handling_minutes)::numeric, 1) AS avg_minutes,
       ROUND((SUM(handling_minutes)::numeric / 60 / 1750), 1) AS fte_equivalent
FROM service_desk_tickets
WHERE self_service_eligible = 'Yes';

-- Q4 — Top stores

SELECT store_number, store_name, COUNT(*) AS tickets
FROM service_desk_tickets
GROUP BY store_number, store_name
ORDER BY tickets DESC
LIMIT 15;

--Q6 — Total calls (KPI)

SELECT COUNT(*) AS total_tickets FROM service_desk_tickets;

--Q8 — Peak seasons

SELECT call_month, COUNT(*) AS tickets
FROM service_desk_tickets
GROUP BY call_month
ORDER BY call_month;


SELECT call_weekday, COUNT(*) AS tickets
FROM service_desk_tickets
GROUP BY call_weekday
ORDER BY tickets DESC;


--Q9 — KB exists for repetitive issues
SELECT knowledgebaseavailable,
       COUNT(*) AS tickets,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM service_desk_tickets
WHERE self_service_eligible = 'Yes'
And knowledgebaseavailable IS NOT NULL
GROUP BY knowledgebaseavailable;



--Automation suitability
SELECT automation_suitability,
       COUNT(*) AS tickets,
		ROUND((SUM(handling_minutes) / 60.0)::numeric, 0) AS hours,
		ROUND((100.0 * COUNT(*) / SUM(COUNT(*)) OVER ())::numeric, 1) AS pct
FROM service_desk_tickets
GROUP BY automation_suitability
ORDER BY tickets DESC;

--Q11 — Automation impact, ranked
SELECT subcategory,
       COUNT(*) AS tickets,
       ROUND((SUM(handling_minutes) / 60.0)::numeric, 0) AS recoverable_hours,
       MODE() WITHIN GROUP (ORDER BY knowledgebaseavailable) AS kb_exists
FROM service_desk_tickets
WHERE automation_suitability = 'High'
GROUP BY subcategory
ORDER BY recoverable_hours DESC;


--First-call resolution vs KB availability
SELECT knowledgebaseavailable,
       first_call_resolution,
       COUNT(*) AS tickets
FROM service_desk_tickets
WHERE self_service_eligible = 'Yes'
  AND knowledgebaseavailable IS NOT NULL
  AND first_call_resolution IS NOT NULL
GROUP BY knowledgebaseavailable, first_call_resolution
ORDER BY knowledgebaseavailable, first_call_resolution;


--Repeat-offender stores
SELECT store_name,
       COUNT(*) AS total,
       SUM(CASE WHEN self_service_eligible='Yes' THEN 1 ELSE 0 END) AS avoidable,
       ROUND(100.0 * SUM(CASE WHEN self_service_eligible='Yes' THEN 1 ELSE 0 END)/COUNT(*),1) AS avoidable_pct
FROM service_desk_tickets
GROUP BY store_name
HAVING COUNT(*) > 100
ORDER BY avoidable_pct DESC
LIMIT 15;


--Automation savings, quantified as money
SELECT ROUND((SUM(handling_minutes) / 60.0)::numeric, 0) AS annual_hours_2yr,
	   ROUND((SUM(handling_minutes) / 60.0 * 25)::numeric, 0) AS cost_at_25ph
FROM service_desk_tickets
WHERE automation_suitability = 'High';