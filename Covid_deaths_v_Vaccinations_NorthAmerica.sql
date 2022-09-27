SELECT location, date, total_cases, new_cases, total_deaths, population
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths`
order by 1,2;

-- Total Cases vs Totoal Death in North America
-- (shows the statistical chances of dying form Covid in North America)
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS death_percetnage
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths` 
WHERE continent="North America" 
ORDER BY 1,2;


-- Total Cases vs Population 
-- (Shows the infected percentage population)
SELECT location, date, population, total_cases, total_deaths, (total_cases/population)*100 AS infected_population
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths` 
WHERE continent="North America" 
ORDER BY 1,2;

-- Locations with the Highest Infection Rate in realtions to Population in North America
SELECT DISTINCT location, population, Max(total_cases) AS highest_infection_count, MAX((total_cases/population))*100 AS infected_population
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths` 
WHERE continent="North America" 
GROUP BY location, population
ORDER BY infected_population DESC;

-- Countries with Highest Death Count per Population in North America
SELECT location, MAX(cast(total_deaths AS int)) AS total_death_count
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths`
WHERE continent="North America" 
GROUP BY location
ORDER BY total_death_count DESC;

-- Continents Highest Death Count per Population
SELECT continent, MAX(cast(total_deaths AS int)) AS total_death_count
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths`
WHERE continent is not null 
GROUP BY continent
ORDER BY total_death_count DESC;

-- Global Death Percentages
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths as int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(new_cases)*100 as death_percetnage
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths` 
WHERE continent is not null
ORDER BY 1,2;


-- Total Poulation vs Vaccinations
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VACS.new_vaccinations, SUM(cast(VACS.new_vaccinations as int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) as continuous_count_vaccinations
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths` DEA
JOIN `covidportfolio-363814.CovidPortfolio.CovidVaccinations` VACS
ON DEA.location = VACS.location
AND DEA.date = VACS.date
WHERE DEA.continent is not null
AND DEA.continent="North America"
ORDER BY 2,3;

--Create Temp Table
DROP TABLE IF EXISTS Total_Pop_v_Vacs_NA
CREATE TABLE Total_Pop_v_Vacs_NA
(continent, location, date, population, new_vaccinations, continuous_count_vaccinations)
INSERT INTO Total_Pop_v_Vacs_NA
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VACS.new_vaccinations, SUM(cast(VACS.new_vaccinations as int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) as continuous_count_vaccinations
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths` DEA
JOIN `covidportfolio-363814.CovidPortfolio.CovidVaccinations` VACS
ON DEA.location = VACS.location
AND DEA.date = VACS.date
--WHERE DEA.continent is not null
AND DEA.continent="North America"
--ORDER BY 2,3;
SELECT *, (continuous_count_vaccinations/population)*100
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths`
AND `covidportfolio-363814.CovidPortfolio.CovidVaccinations`

-- Views for Data Viz
CREATE VIEW Total_Pop_v_Vacs_NA AS
SELECT DEA.continent, DEA.location, DEA.date, DEA.population, VACS.new_vaccinations, SUM(cast(VACS.new_vaccinations as int)) OVER (PARTITION BY DEA.location ORDER BY DEA.location, DEA.date) as continuous_count_vaccinations
FROM `covidportfolio-363814.CovidPortfolio.CovidDeaths` DEA
JOIN `covidportfolio-363814.CovidPortfolio.CovidVaccinations` VACS
ON DEA.location = VACS.location
AND DEA.date = VACS.date
WHERE DEA.continent is not null
AND DEA.continent="North America"