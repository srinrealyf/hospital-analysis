-------------------- 1) Payers Table (Insurance)

SELECT DISTINCT `NAME` FROM payers;

-------------------- 2) 

-- 1) How does the length of stay vary across different encounter classes for different age groups?

SELECT
    e.EncounterClass,
    CASE
        WHEN FLOOR(DATEDIFF(CURDATE(), p.BirthDate) / 365) < 18 THEN 'Child'
        WHEN FLOOR(DATEDIFF(CURDATE(), p.BirthDate) / 365) BETWEEN 18 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeGroup,
    COUNT(*) AS EncounterCount,  -- Number of encounters per class and age group
    AVG(TIMESTAMPDIFF(HOUR, e.START_T, e.STOP_T)) AS AvgLengthOfStay_Hours,  -- Average length of stay in hours
    AVG(FLOOR(DATEDIFF(CURDATE(), p.BirthDate) / 365)) AS AvgPatientAge  -- Average age of patients
FROM encounters e
JOIN patients p ON e.Patient = p.Id
WHERE e.START_T IS NOT NULL AND e.STOP_T IS NOT NULL
GROUP BY e.EncounterClass, AgeGroup
ORDER BY ENCOUNTERCLASS;

-- 2) What percentage of total encounters resulted in patient death, and what were the most frequent encounter classes associated with such cases?

SELECT 
	e.ENCOUNTERCLASS,
    COUNT(e.ID) as EncounterCount,
    COUNT(CASE WHEN p.DEATHDATE IS NOT NULL THEN 1 END) AS Deaths,
    (COUNT(CASE WHEN p.DEATHDATE IS NOT NULL THEN 1 END) / COUNT(e.ID)) * 100 AS DeathPercentage
FROM encounters e
JOIN PATIENTS p 
	ON e.PATIENT = p.ID
GROUP BY e.ENCOUNTERCLASS;

-- 3) What are the most common reasons for patient encounters across different age groups or ethnicities?

SELECT
	p.Ethnicity,
    CASE
		WHEN FLOOR(DATEDIFF(CURDATE(), p.BirthDate) / 365) < 18 THEN 'CHILD'
        WHEN FLOOR(DATEDIFF(CURDATE(), p.BirthDate) / 365) > 18 BETWEEN 18 AND 64 THEN 'ADULT'
        ELSE 'SENIOR'
	END AS AgeGroup,
    e.ReasonDescription,
    COUNT(e.ID) AS EncounterCount
FROM encounters e
JOIN patients p 
	ON e.patient = p.ID
GROUP BY p.Ethnicity, AgeGroup, e.ReasonDescription
ORDER BY EncounterCount DESC;
    
-- 4) Are certain encounter classes more prevalent in specific states or cities based on the patient's residence?

SELECT
	p.CITY,
    e.ENCOUNTERCLASS,
    COUNT(e.ID) AS TotalEncounters
FROM encounters e
JOIN patients p
	ON e.patient = p.ID
GROUP BY p.CITY, e.ENCOUNTERCLASS
ORDER BY TotalEncounters DESC;

-- 5) What is the average total claim cost for encounters involving patients of different ethnicities or races, and how does payer coverage vary by race or ethnicity?

SELECT 
	p.RACE,
    P.ETHNICITY,
    ROUND(AVG(e.Total_Claim_Cost),2) AS AvgTotalClaimCost,
    ROUND(AVG(e.Payer_Coverage),2) AS AvgPayerCoverage
FROM encounters e
JOIN patients p
	on e.patient = p.ID
GROUP BY p.RACE, P.ETHNICITY;

-- 6) What is the correlation between base encounter cost and total claim cost, and does this relationship differ by encounter class?

SELECT
	e.ENCOUNTERCLASS,
    ROUND(AVG(e.BASE_ENCOUNTER_COST),2) AS AvgBaseCost,
    ROUND(AVG(e.TOTAL_CLAIM_COST),2) AS AvgTotalClaimCost,
    ROUND((AVG(e.BASE_ENCOUNTER_COST)/AVG(e.TOTAL_CLAIM_COST)),2) AS CostRatio
FROM encounters e
JOIN patients p
	ON e.Patient = p.ID
GROUP BY e.ENCOUNTERCLASS;

-- 7) What are the top organizations by total claim cost, and how does the average cost vary across organizations?

SELECT
	o.`NAME` AS OrganizationName,
    ROUND(SUM(e.TOTAL_CLAIM_COST),2) AS TotalCost,
    ROUND(AVG(e.TOTAL_CLAIM_COST),2) AS AvgTotalClaimCost
FROM encounters e
JOIN organizations o
	ON e.`organization` = o.`ID`
GROUP BY o.`NAME`;

-- 8) How does payer coverage differ across different payer organizations for the same types of encounters?

SELECT
	p.`NAME` AS PayerName,
    e.ENCOUNTERCLASS,
    ROUND(AVG(e.Payer_Coverage),2) AS AvgPayerCoverage
FROM encounters e
JOIN payers p
	ON e.payer = p.ID
GROUP BY p.`NAME`, e.`EncounterClass`
ORDER BY AvgPayerCoverage DESC;

-- 9) Are there significant discrepancies between payer coverage and the actual total claim cost for specific payer organizations?

SELECT
	p.`NAME` AS PayerName,
    ROUND(AVG(e.PAYER_COVERAGE),2) AS AvgPayerCoverage,
    ROUND(AVG(e.TOTAL_CLAIM_COST),2) AS AvgTotalClaimCost,
    ROUND((AVG(e.PAYER_COVERAGE) - AVG(e.TOTAL_CLAIM_COST)),2) AS CoverageDiscrepancies
FROM encounters e
JOIN payers p
	ON e.payer = p.ID
GROUP BY p.`Name`;

-- 10) What are the top 10 reasons contributing to the highest average total claim cost for encounters?

SELECT
	e.ReasonDescription,
	ROUND(AVG(e.TOTAL_CLAIM_COST),2) AS AvgTotalClaimCost
FROM encounters e
JOIN payers p
	ON e.payer = p.ID
GROUP BY e.ReasonDescription
ORDER BY AvgTotalClaimCost DESC
LIMIT 10;

-- 11) How does the distribution of encounter classes differ by the organization's geographic location?

SELECT
    o.City,
    o.State,
    e.EncounterClass,
    COUNT(e.Id) AS EncounterCount
FROM encounters e
JOIN organizations o ON e.Organization = o.Id
GROUP BY o.City, o.State, e.EncounterClass
ORDER BY EncounterCount DESC;

-- 12) Which organizations have the highest and lowest average encounter durations?

SELECT
	o.`NAME`,
    AVG(TIMESTAMPDIFF(HOUR, e.START_T, e.STOP_T)) AS AvgEncounterDuration
FROM encounters e
JOIN `organizations` o 
	ON e.`organization` = o.ID
GROUP BY o.`NAME`;

-- 13) How does the total claim cost for similar types of encounters vary by organizations located in different cities or states?

SELECT
	o.City,
    o.STATE,
    e.ENCOUNTERCLASS,
    AVG(e.TOTAL_CLAIM_COST) AS AvgTotalClaimCost
FROM encounters e
JOIN organizations o
	ON e.`organization` = o.ID
GROUP BY o.City, o.STATE, e.ENCOUNTERCLASS;

-- 14) Which procedures are most frequently performed during specific types of encounters?

SELECT
    e.EncounterClass,                           
    e.ReasonDescription,                       
    COUNT(e.Id) AS TotalEncounters,             
    ROUND(AVG(e.Base_Encounter_Cost),2) AS AvgBaseCost, 
    ROUND(AVG(e.Total_Claim_Cost),2) AS AvgClaimCost,    
    ROUND(SUM(e.Payer_Coverage),2) AS TotalPayerCoverage 
FROM encounters e
WHERE e.Start_T IS NOT NULL AND e.Stop_T IS NOT NULL 
GROUP BY e.EncounterClass, e.ReasonDescription  
ORDER BY TotalEncounters DESC;                 

-- 15) What are the most common reasons for encounters by age group (Child, Adult, Senior)?

SELECT
    CASE
        WHEN FLOOR(DATEDIFF(CURDATE(), p.BirthDate) / 365) < 18 THEN 'Child'
        WHEN FLOOR(DATEDIFF(CURDATE(), p.BirthDate) / 365) BETWEEN 18 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeGroup,
    e.ReasonDescription,                               -- Description of the reason for the encounter
    COUNT(e.Id) AS EncounterCount                      -- Count of encounters for each reason
FROM encounters e
JOIN patients p ON e.Patient = p.Id                  -- Join encounters with patients
GROUP BY AgeGroup, e.ReasonDescription               -- Group by age group and reason description
ORDER BY EncounterCount DESC;                        -- Order by encounter count in descending order




