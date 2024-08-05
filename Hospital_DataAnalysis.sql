-- Data Cleaning and Exploratory Analysis

SELECT 
    *
FROM
    healthcare_dataset;


CREATE TABLE hospitals_data LIKE healthcare_dataset;

insert hospitals_data
select *
from healthcare_dataset;

-- Standardizing the data
SELECT 
    `name`
FROM
    hospitals_data;

UPDATE hospitals_data 
SET 
    `name` = UPPER(`name`);



-- Duplicate values removed
with duplicate_cte as 
(
Select *,
row_number() over(
partition by `name`, age, gender, Hospital, `Medical Condition`) as row_num
from hospitals_data
)
SELECT 
    *
FROM
    duplicate_cte
WHERE
    row_num > 1;


CREATE TABLE `hospitals_data2` (
    `Name` TEXT,
    `Age` INT DEFAULT NULL,
    `Gender` TEXT,
    `Blood Type` TEXT,
    `Medical Condition` TEXT,
    `Date of Admission` TEXT,
    `Doctor` TEXT,
    `Hospital` TEXT,
    `Insurance Provider` TEXT,
    `Billing Amount` DOUBLE DEFAULT NULL,
    `Room Number` INT DEFAULT NULL,
    `Admission Type` TEXT,
    `Discharge Date` TEXT,
    `Medication` TEXT,
    `Test Results` TEXT,
    `row_num` INT
)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;


insert into hospitals_data2
select *,
row_number() over(
partition by `name`, age, gender, Hospital, `Medical Condition`) as row_num
from hospitals_data
;

SELECT 
    *
FROM
    hospitals_data2;

DELETE FROM hospitals_data2 
WHERE
    row_num > 1;


SELECT 
    `Name`, age, Hospital, Gender, COUNT(*)
FROM
    hospitals_data2
GROUP BY `Name` , age , Hospital , Gender
HAVING COUNT(*) > 1;

-- change date format from text to date
SELECT 
    `date of admission`, `discharge date`
FROM
    hospitals_data2;

UPDATE hospitals_data2 
SET 
    `date of admission` = STR_TO_DATE(`date of admission`, '%Y-%m-%d'),
    `discharge date` = STR_TO_DATE(`discharge date`, '%Y-%m-%d');

alter table hospitals_data2
modify column `date of admission` date,
modify column `discharge date` date;

alter table hospitals_data2
drop column row_num;

SELECT 
    *
FROM
    hospitals_data2;

-- Exploratory Analysis
SELECT 
    COUNT(Gender)
FROM
    hospitals_data2;

SELECT 
    gender,
    COUNT(Gender) AS count,
    SUM(`Billing Amount`) AS total_billing_amount
FROM
    hospitals_data2
GROUP BY Gender
ORDER BY total_billing_amount DESC;

with medcon_by_gender as (
	SELECT 
    Gender, `Medical Condition`, COUNT(Gender) AS no_of_patient
FROM
    hospitals_data2
GROUP BY Gender , `Medical Condition`
ORDER BY `Medical Condition`
)
SELECT 
    *
FROM
    medcon_by_gender;

with AgeGroups as (
    select 
        gender, 
        case 
            when age < 26 THEN ' 25 Below'
            when age >= 26 AND age <= 50 THEN '26 to 50'
            when age > 50 THEN 'Over 50'
        end as age_group
    from 
        hospitals_data2
)
SELECT 
    age_group, gender, COUNT(*) AS count
FROM
    AgeGroups
GROUP BY age_group , gender
ORDER BY age_group ASC;
    
    

with AgeGroups2 as (
    select 
         `Medical Condition`,
        case 
            when age < 26 THEN ' 25 Below'
            when age >= 26 AND age <= 50 THEN '26 to 50'
            when age > 50 THEN 'Over 50'
        end as age_group
    from 
        hospitals_data2
)
 SELECT 
    age_group, `Medical Condition`, COUNT(*) AS count
FROM
    AgeGroups2
GROUP BY age_group , `Medical Condition`
ORDER BY age_group ASC;
     
 
SELECT 
    `Medical Condition`, SUM(`Billing Amount`) AS Amount_Billed
FROM
    hospitals_data2
GROUP BY `Medical Condition`;







 








