-- Healthcare Data Analysis & Disease Prediction


CREATE DATABASE IF NOT EXISTS healthcare_db;
USE healthcare_db;



-- Table 1: Demographics
CREATE TABLE patients (
    Patient_ID INT PRIMARY KEY,
    Age INT NOT NULL,
    Gender VARCHAR(10) NOT NULL
);

-- Table 2: Clinical History & Symptoms
CREATE TABLE medical_records (
    Record_ID INT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    Smoking TINYINT(1) NOT NULL,
    Diabetes TINYINT(1) NOT NULL,
    ChestPainType VARCHAR(50) NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES patients(Patient_ID) ON DELETE CASCADE
);

-- Table 3: Clinical Test Measurements
CREATE TABLE test_results (
    Test_ID INT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    RestingBP INT NOT NULL,
    Cholesterol INT NOT NULL,
    FastingBS TINYINT(1) NOT NULL,
    MaxHR INT NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES patients(Patient_ID) ON DELETE CASCADE
);

-- Table 4: Confirmed Diagnosis Outcomes
CREATE TABLE diagnoses (
    Diagnosis_ID INT PRIMARY KEY,
    Patient_ID INT NOT NULL,
    HeartDisease TINYINT(1) NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES patients(Patient_ID) ON DELETE CASCADE
);



-- Query 1: Join all 4 tables into a complete analytical master view
CREATE OR REPLACE VIEW v_patient_full_profile AS
SELECT 
    p.Patient_ID,
    p.Age,
    p.Gender,
    m.Smoking,
    m.Diabetes,
    m.ChestPainType,
    t.RestingBP,
    t.Cholesterol,
    t.FastingBS,
    t.MaxHR,
    d.HeartDisease
FROM patients p
JOIN medical_records m ON p.Patient_ID = m.Patient_ID
JOIN test_results t    ON p.Patient_ID = t.Patient_ID
JOIN diagnoses d       ON p.Patient_ID = d.Patient_ID;

-- Query 2: Prevalence rate across Age Groups and Gender
SELECT 
    CASE 
        WHEN p.Age < 40 THEN '<40 Young'
        WHEN p.Age BETWEEN 40 AND 55 THEN '40-55 Middle'
        WHEN p.Age BETWEEN 56 AND 70 THEN '56-70 Senior'
        ELSE '70+ Geriatric'
    END AS Age_Group,
    p.Gender,
    COUNT(p.Patient_ID) AS Total_Patients,
    SUM(d.HeartDisease) AS Positive_Cases,
    ROUND(AVG(d.HeartDisease) * 100, 2) AS Heart_Disease_Rate_Pct
FROM patients p
JOIN diagnoses d ON p.Patient_ID = d.Patient_ID
GROUP BY Age_Group, p.Gender
ORDER BY Age_Group, p.Gender;

-- Query 3: Multi-morbidity impact (Smoking + Diabetes vs Disease Rate)
SELECT 
    m.Smoking,
    m.Diabetes,
    COUNT(m.Patient_ID) AS Patient_Count,
    SUM(d.HeartDisease) AS Disease_Cases,
    ROUND(AVG(d.HeartDisease) * 100, 2) AS Risk_Percentage
FROM medical_records m
JOIN diagnoses d ON m.Patient_ID = d.Patient_ID
GROUP BY m.Smoking, m.Diabetes
ORDER BY Risk_Percentage DESC;

-- Query 4: Clinical biometrics breakdown by Chest Pain Category
SELECT 
    m.ChestPainType,
    COUNT(m.Patient_ID) AS Total_Patients,
    ROUND(AVG(t.RestingBP), 1) AS Avg_Resting_BP,
    ROUND(AVG(t.Cholesterol), 1) AS Avg_Cholesterol,
    ROUND(AVG(t.MaxHR), 1) AS Avg_Max_HR,
    ROUND(AVG(d.HeartDisease) * 100, 2) AS Disease_Incidence_Pct
FROM medical_records m
JOIN test_results t ON m.Patient_ID = t.Patient_ID
JOIN diagnoses d    ON m.Patient_ID = d.Patient_ID
GROUP BY m.ChestPainType
ORDER BY Disease_Incidence_Pct DESC;

-- Query 5: Window Function - Top 3 highest cholesterol patients per age cohort
WITH CohortRankings AS (
    SELECT 
        p.Patient_ID,
        p.Age,
        p.Gender,
        t.Cholesterol,
        d.HeartDisease,
        DENSE_RANK() OVER (
            PARTITION BY CASE 
                WHEN p.Age < 50 THEN 'Under 50' 
                ELSE '50 and Above' 
            END 
            ORDER BY t.Cholesterol DESC
        ) AS rank_in_cohort
    FROM patients p
    JOIN test_results t ON p.Patient_ID = t.Patient_ID
    JOIN diagnoses d    ON p.Patient_ID = d.Patient_ID
)
SELECT * 
FROM CohortRankings 
WHERE rank_in_cohort <= 3;