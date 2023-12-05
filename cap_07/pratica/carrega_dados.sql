CREATE SCHEMA cap07 CHARACTER SET UTF8MB4;

USE cap07;

CREATE TABLE `covid_mortes` (
  `iso_code` text,
  `continent` text,
  `location` text,
  `date` text,
  `population` int DEFAULT NULL,
  `total_cases` int DEFAULT NULL,
  `new_cases` int DEFAULT NULL,
  `new_cases_smoothed` text,
  `total_deaths` text,
  `new_deaths` text,
  `new_deaths_smoothed` text,
  `total_cases_per_million` double DEFAULT NULL,
  `new_cases_per_million` double DEFAULT NULL,
  `new_cases_smoothed_per_million` text,
  `total_deaths_per_million` text,
  `new_deaths_per_million` text,
  `new_deaths_smoothed_per_million` text,
  `reproduction_rate` text,
  `icu_patients` text,
  `icu_patients_per_million` text,
  `hosp_patients` text,
  `hosp_patients_per_million` text,
  `weekly_icu_admissions` text,
  `weekly_icu_admissions_per_million` text,
  `weekly_hosp_admissions` text,
  `weekly_hosp_admissions_per_million` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `covid_vacinacao` (
  `iso_code` text,
  `continent` text,
  `location` text,
  `date` text,
  `new_tests` bigint DEFAULT NULL,
  `total_tests` text,
  `total_tests_per_thousand` text,
  `new_tests_per_thousand` bigint DEFAULT NULL,
  `new_tests_smoothed` text,
  `new_tests_smoothed_per_thousand` text,
  `positive_rate` text,
  `tests_per_case` text,
  `tests_units` text,
  `total_vaccinations` text,
  `people_vaccinated` text,
  `people_fully_vaccinated` text,
  `new_vaccinations` text,
  `new_vaccinations_smoothed` text,
  `total_vaccinations_per_hundred` text,
  `people_vaccinated_per_hundred` text,
  `people_fully_vaccinated_per_hundred` text,
  `new_vaccinations_smoothed_per_million` text,
  `stringency_index` double DEFAULT NULL,
  `population_density` double DEFAULT NULL,
  `median_age` double DEFAULT NULL,
  `aged_65_older` double DEFAULT NULL,
  `aged_70_older` double DEFAULT NULL,
  `gdp_per_capita` double DEFAULT NULL,
  `extreme_poverty` text,
  `cardiovasc_death_rate` double DEFAULT NULL,
  `diabetes_prevalence` double DEFAULT NULL,
  `female_smokers` text,
  `male_smokers` text,
  `handwashing_facilities` double DEFAULT NULL,
  `hospital_beds_per_thousand` double DEFAULT NULL,
  `life_expectancy` double DEFAULT NULL,
  `human_development_index` double DEFAULT NULL,
  `excess_mortality` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SET GLOBAL local_infile = true;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_07\\scripts_e_datasets_do_cap\\2-Scripts-Cap07\\EstudoCaso1\\covid_mortes.csv"    INTO TABLE `cap07`.`covid_mortes`    CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "E:\\OneDrive\\Desktop\\sql_para_data_science\\cap_07\\scripts_e_datasets_do_cap\\2-Scripts-Cap07\\EstudoCaso1\\covid_vacinacao.csv" INTO TABLE `cap07`.`covid_vacinacao` CHARACTER SET UTF8MB4 FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n' IGNORE 1 LINES;