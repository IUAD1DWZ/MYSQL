#1
Select *
From mydb.infectious_cases

#2

CREATE DATABASE IF NOT EXISTS pandemic;
USE pandemic;

CREATE TABLE entities (
    entity_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE infectious_cases (
    case_id INT AUTO_INCREMENT PRIMARY KEY,
    entity_id INT NOT NULL,
    code VARCHAR(20) NULL,
    year YEAR NOT NULL,
    number_yaws DECIMAL(18,6) NULL,
    polio_cases DECIMAL(18,6) NULL,
    cases_guinea_worm DECIMAL(18,6) NULL,
    number_rabies DECIMAL(18,6) NULL,
    number_malaria DECIMAL(18,6) NULL,
    number_hiv DECIMAL(18,6) NULL,
    number_tuberculosis DECIMAL(18,6) NULL,
    number_smallpox DECIMAL(18,6) NULL,
    number_cholera_cases DECIMAL(18,6) NULL,
    CONSTRAINT fk_infectious_cases_entities
        FOREIGN KEY (entity_id) REFERENCES entities(entity_id)
);


INSERT INTO pandemic.entities (entity_name)
SELECT DISTINCT Entity
FROM mydb.infectious_cases;

INSERT INTO pandemic.infectious_cases (
    entity_id, code, year,
    number_yaws, polio_cases, cases_guinea_worm,
    number_rabies, number_malaria, number_hiv,
    number_tuberculosis, number_smallpox, number_cholera_cases
)
SELECT
    e.entity_id,
    r.Code,
    r.Year,
    NULLIF(r.Number_yaws, ''),
    NULLIF(r.polio_cases, ''),
    NULLIF(r.cases_guinea_worm, ''),
    NULLIF(r.Number_rabies, ''),
    NULLIF(r.Number_malaria, ''),
    NULLIF(r.Number_hiv, ''),
    NULLIF(r.Number_tuberculosis, ''),
    NULLIF(r.Number_smallpox, ''),
    NULLIF(r.Number_cholera_cases, '')
FROM mydb.infectious_cases r
JOIN entities e ON e.entity_name = r.Entity;

#3

SELECT
    e.entity_name AS Entity,
    ic.code AS Code,
    AVG(CAST(ic.number_rabies AS DECIMAL(18,6))) AS avg_rabies,
    MIN(CAST(ic.number_rabies AS DECIMAL(18,6))) AS min_rabies,
    MAX(CAST(ic.number_rabies AS DECIMAL(18,6))) AS max_rabies,
    SUM(CAST(ic.number_rabies AS DECIMAL(18,6))) AS sum_rabies
FROM infectious_cases ic
JOIN entities e ON ic.entity_id = e.entity_id
WHERE ic.number_rabies IS NOT NULL AND ic.number_rabies <> ''
GROUP BY e.entity_name, ic.code
ORDER BY avg_rabies DESC
LIMIT 10;

#4

SELECT
    Year,
    STR_TO_DATE(CONCAT(Year, '-01-01'), '%Y-%m-%d') AS year_start_date,
    CURDATE() AS today_date,
    TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(CONCAT(Year, '-01-01'), '%Y-%m-%d'),
        CURDATE()
    ) AS years_diff
FROM infectious_cases;

5.1

DROP FUNCTION IF EXISTS year_diff;
DELIMITER $$

CREATE FUNCTION year_diff(input_year INT)
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(CONCAT(input_year, '-01-01'), '%Y-%m-%d'),
        CURDATE()
    );
END$$

DELIMITER ;

5.2

SELECT
    `Year`,
    year_diff(`Year`) AS years_diff
FROM infectious_cases;