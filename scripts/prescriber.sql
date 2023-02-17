-- 1. 
--     a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
    
SELECT npi, nppes_provider_first_name, total_claim_count_ge65
FROM prescriber
LEFT JOIN prescription
USING (npi)
WHERE total_claim_count_ge65 IS NOT NULL 
ORDER BY total_claim_count_ge65 DESC;
                         
-- Bruce 3062
	
--     b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.


SELECT npi, nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, total_claim_count_ge65
FROM prescriber
LEFT JOIN prescription
USING (npi)
WHERE total_claim_count_ge65 IS NOT NULL 
ORDER BY total_claim_count_ge65 DESC;
                         
--1881634483	"BRUCE"	"PENDLEY"	"Family Practice"	3062.0

-- 2. 
--     a. Which specialty had the most total number of claims (totaled over all drugs)?

SELECT specialty_description, COUNT(total_claim_count_ge65) AS total_count
FROM prescriber
LEFT JOIN prescription
USING (npi)
GROUP BY specialty_description
ORDER BY total_count DESC;

-- Family Practice 

--     b. Which specialty had the most total number of claims for opioids?

SELECT specialty_description AS category, COUNT(total_claim_count_ge65) AS total, opioid_drug_flag AS OP
FROM prescriber 
LEFT JOIN prescription
ON prescriber.npi = prescription.npi
INNER JOIN drug
ON prescription.drug_name = drug.drug_name
GROUP BY category, OP
ORDER BY total DESC;

-- "Nurse Practitioner"


--     c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?



--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

-- 3. 
--     a. Which drug (generic_name) had the highest total drug cost?

SELECT prescription.drug_name , generic_name, total_drug_cost
FROM prescription
LEFT JOIN drug
ON prescription.drug_name = drug.drug_name
ORDER BY total_drug_cost DESC;

--"PIRFENIDONE"

--     b. Which drug (generic_name) has the hightest total cost per day? **Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.** 

SELECT prescription.drug_name AS drug, generic_name AS generic, MAX(total_drug_cost/total_day_supply) AS total_daily_cost
FROM prescription
LEFT JOIN drug
ON prescription.drug_name = drug.drug_name
GROUP BY drug, generic
ORDER BY total_daily_cost DESC
LIMIT 10;

--"GAMMAGARD LIQUID"	"IMMUN GLOB G(IGG)/GLY/IGA OV50"
-- 4. 
--     a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.

-- SELECT drug_name
-- FROM drug
-- CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- ELSE 'neither' END AS drug_type




--     b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.




-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:** The cbsa table contains information for all states, not just Tennessee.


SELECT COUNT(*)
FROM cbsa
LEFT JOIN fips_county
ON cbsa.fipscounty = fips_county.fipscounty
WHERE state = 'TN';

--42

--     b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.


SELECT cbsa AS cbsa,cbsaname AS cbsaname, SUM(population) AS total_pop
FROM cbsa
LEFT JOIN population
ON cbsa.fipscounty = population.fipscounty
GROUP BY cbsa,cbsaname
ORDER BY total_pop ASC;

-- CBSA largest is "Nashville-Davidson--Murfreesboro--Franklin, TN"	1830410
-- CBSA smallest "Morristown, TN"	116352

--     c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.

SELECT fips_county.fipscounty, population.population, county
FROM population
LEFT JOIN fips_county
ON population.fipscounty = fips_county.fipscounty
WHERE fips_county.fipscounty NOT IN (SELECT fipscounty FROM cbsa)
ORDER BY population DESC
LIMIT 1;

--"SEVIER"

-- 6. 
--     a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.

SELECT 
FROM prepscription      
WHERE



--     b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.

--     c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.

-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

--     a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

--     b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
--     c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.