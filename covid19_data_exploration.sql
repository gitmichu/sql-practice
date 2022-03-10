/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

-- Dataset check

SELECT TOP 10 *
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY location, date;


-- Select data to start exploring

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY iso_code, continent;


-- Total Cases vs Total Deaths in Poland
-- Shows likelihood of dying if you contract covid in Poland

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100, 2) as death_prct
FROM CovidDeaths
WHERE location LIKE 'Poland'
ORDER BY location, date;

-- Total Cases vs Population in Poland
-- Shows percentage of Polish population being infecetd up to 24.12.2021

SELECT location, date, total_cases, ROUND((total_cases/population)*100, 2) AS prct_pop_infected
FROM CovidDeaths
WHERE location LIKE 'Poland'
ORDER BY pop_infected_prct DESC;

-- Countries with Highest Infection Rate compared to whole Population

SELECT location, population, MAX(total_cases) AS highest_infection_count, ROUND(MAX(total_cases/population)*100, 2) AS prct_pop_infected
FROM CovidDeaths
GROUP BY location, population
ORDER BY prct_pop_infected DESC;


-- Countries with highest death count per population

SELECT location, MAX(CAST(total_deaths as INT)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY total_death_count DESC;

-- Continets with highest death count per population

SELECT continent, MAX(CAST(total_deaths as INT)) AS total_death_count
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY total_death_count DESC;

-- Global total cases, total deaths and death percentage

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, ROUND(SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100, 2) AS death_prct
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY total_cases, total_deaths;

-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths AS dea
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.population;

-- Using CTE to perform Calculation on Partition By in previous query

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
	(
		SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
		SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
		--, (RollingPeopleVaccinated/Population)*100
		FROM CovidDeaths AS dea
		JOIN CovidVaccinations AS vac
		ON dea.location = vac.location
		AND dea.date = vac.date	
		WHERE dea.continent IS NOT NULL
		-- ORDER BY dea.location, dea.population
	)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac;

-- Using Temp Table to perform Calculation on Partition By in previous query

DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
	(
		continent nvarchar(255),
		location nvarchar(255),
		date datetime,
		population numeric,
		new_vaccinations numeric,
		rollingpeoplevaccinated numeric
	)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
FROM CovidDeaths AS dea
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL
-- ORDER BY dea.location, dea.population;

SELECT TOP 100 *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated;

-- Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(BIGINT, vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/Population)*100
FROM CovidDeaths AS dea
JOIN CovidVaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

