
--select the data we are going to be using 

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM PortfolioProject..CovidDeaths
--order by 1,2

-- 1. Looking at total cases vs total deaths

-- Shows the likelihood of dying if you contract COVID in your country.

--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentaje
--FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
--order by 1,2

-- 2. Looking at total cases vs Population

--Shows what percentaje of population was infected by COVID	

--SELECT location, date, population, total_cases,  (total_cases/population)*100 as InfectedPercentaje
--FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
--order by 1,2

--3. Looking at Countries with highest INFECTION rates compared to Population

--SELECT location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population)*100 as HighestInfectedPercentaje
--FROM PortfolioProject..CovidDeaths
--Group by location, population
--order by HighestInfectedPercentaje Desc

--4. Looking at Countries with highest DEATH rates compared to Population

--SELECT location, population, MAX(cast(total_deaths as int)) as HighestDeathCount, (MAX(cast(total_deaths as int))/population)*100 as HighestDeathsPercentaje
--FROM PortfolioProject..CovidDeaths
--where continent is not null
--Group by location, population
--order by HighestDeathsPercentaje Desc

--5.Looking at COUNTRIES with highest death counts

--SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths
--where continent is not null
--Group by location
--order by TotalDeathCount Desc

--6.Looking at CONTINENTS with highest death counts (using location)

--SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths
--where continent is null
--Group by location
--order by TotalDeathCount Desc

--7.Looking at CONTINENTS with highest death counts (another way using continent)

--SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths
--where continent is not null
--Group by continent
--order by TotalDeathCount Desc

--8. Worldwide evolution of total deaths vs total cases and death percentage by date

--SELECT date, SUM(new_cases) as Total_cases_Count, SUM(cast(new_deaths as int)) as New_Deaths_Count, (SUM(cast(new_deaths as int)) / SUM(new_cases)) * 100 as World_Death_percentaje
--from CovidDeaths
--where continent is not null
--group by date
--order by date

--9. Woldwide sum of total cases vs Deaths count and global percentage. 

--SELECT SUM(new_cases) as Total_cases_Count, SUM(cast(new_deaths as int)) as New_Deaths_Count, (SUM(cast(new_deaths as int)) / SUM(new_cases)) * 100 as World_Death_percentaje
--from CovidDeaths
--where continent is not null

--10. Covid deaths and covid vaccinations table join on location and death 

--select *
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date

--mi ejemplo (TOTAL VACCINATIONS BY COUNTRY)
--Select dea.location, dea.population, MAX(cast(vac.total_vaccinations as int)) as total_vaccinations
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--group by dea.location, dea.population
--order by total_vaccinations desc

--11. CREATING A COLLUMN WHERE THAT DISPLAYS THE INCREMENT OF TOTAL VACCINATIONS BY DAY

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

--12. To use the "RollingPeopleVaccinated" Values in further calculations we need to create a CTE or Temp Table

--Creating a CTE Called Popvsvac (OPTION 1)

--With Popvsvac as

-- (Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--)

--select *, RollingPeopleVaccinated/population * 100 as EvolutionPercent
--from Popvsvac

--Creating a Temp Table (option 2)
--Drop table if exists #PercentPopulationVaccinated -- this is used to overwrite changes in a saved table, it just delete it and create a new table

--Create Table #PercentPopulationVaccinated
--(Continent nvarchar(255),
--  Location nvarchar(255),
--  Date datetime,
--  Population numeric,
--  New_vaccinations numeric,
--  RollingPeopleVaccinated numeric
-- )

-- insert into #PercentPopulationVaccinated

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null

--select * from 
--#PercentPopulationVaccinated

----*-----CREATING VIEWS TO STORE  FOR LATER DATA VISUALIZATION  ----*----

-- View #1 Rolling People Vaccinated by Day (worldwide)

--Create View RollingPeopleVaccinatedbyDay as 

--Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null

--View #2 Highest Infected Percentaje compared to population by country

--Create View HighestInfectedPercentajebyCountry as 

--SELECT location, population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/population)*100 as HighestInfectedPercentaje
--FROM PortfolioProject..CovidDeaths
--where continent is not null
--Group by location, population

--View #3 Highest Death Count of Deaths and Percentaje compared to population by country

--Create View HighestDeathPercentajebyCountry as 

--SELECT location, population, MAX(cast(total_deaths as int)) as HighestDeathCount, (MAX(cast(total_deaths as int))/population)*100 as HighestDeathsPercentaje
--FROM PortfolioProject..CovidDeaths
--where continent is not null
--Group by location, population

--View #4  Total people vaccinated and Percentaje of the population by country

--Create View HighestVaccinatedPercentajebyCountry as 

--Select dea.location, dea.population, MAX(cast(vac.total_vaccinations as int)) as total_vaccinations, (MAX(cast(vac.total_vaccinations as int))/dea.population) * 100 as percentaje_vaccinated
--from CovidDeaths dea
--join CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null
--group by dea.location, dea.population

--View #5 Total Death Count by Continent

--Create View TotalDeathCountbyContinent as

--SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
--from CovidDeaths
--where continent is not null
--Group by continent


--View #6 Worldwide Total infected people vs Total Deaths (Worldwide Covid Death Rate)

--Create View WorldwideCovidDeathrate as

--SELECT SUM(new_cases) as Total_cases_Count, SUM(cast(new_deaths as int)) as Total_Deaths_Count, (SUM(cast(new_deaths as int)) / SUM(new_cases)) * 100 as World_Death_percentaje
--from CovidDeaths
--where continent is not null







