select *
from PortfolioProject.dbo.[covid deaths]
where continent is not null
order by 3,4

--select *
--from PortfolioProject.dbo.[covid vaccine]
--order by 3,4

-- select data that we will be using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject.dbo.[covid deaths]
where continent is not null
order by 1,2

-- looking at the total cases versus total deaths
--- shows the likelyhood of dieing if you contact covid

select location, date, total_cases,  total_deaths, (cast(total_deaths as float)/cast(total_cases as float))* 100 as DeathPercentage--had error based on nvarchar on the calculation so you have to change the division operation to float so the nvarchar can accommodate the number of entry
from PortfolioProject.dbo.[covid deaths]
where location like '%states%'
order by 1,2

--- total cases vs population

select location, date, population, total_cases, (cast(total_cases as float)/ cast(population as float)) * 100  as PercentOfPopulationInfected
from PortfolioProject.dbo.[covid deaths]
where continent is not null
order by 1,2

--looking at countries with highest infection rate compared to population

select location, population, max(total_cases) as HighestInfectionCount, max(cast(total_cases as float)/ cast(population as float)) * 100  as PercentOfPopulationInfected
from PortfolioProject.dbo.[covid deaths]
where continent is not null
group by location, population
order by PercentOfPopulationInfected desc

--this is showing the countries with the highest death count per population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.[covid deaths]
where continent is not null
group by location
order by TotalDeathCount desc

--LET'S BREAK BY CONTINENT


select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.[covid deaths]
where continent is null
group by location
order by TotalDeathCount desc

--showing contiinents with the highest death count oer population

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject.dbo.[covid deaths]
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as float)) as total_deaths, 
sum(cast(new_deaths as float)) / sum(new_cases) * 100 as DeathPercentage  
from PortfolioProject.dbo.[covid deaths]
where continent is not null
--group by date
order by 1,2


--looking at total population vs hospital admission

select dea.continent, dea.location, dea.date, dea.population
from PortfolioProject.dbo.[covid deaths] dea
join PortfolioProject..[covid vaccine] vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

--select PortfolioProject..[covid vaccine].
--from PortfolioProject..[covid vaccine] vac
--join PortfolioProject..[covid deaths] dea
--on vac.location=dea.location
--and vac.date=dea.date
--where dea.continent is not null
--order by 1,2,3

---total death vs total vaccination

--SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
--  SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--FROM `covid-da-case-study.covid_data.covid_deaths` AS dea
--JOIN `covid-da-case-study.covid_data.covid_vaccinations` AS vac
--  ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3;

---- Using CTE to perform calculation on Partition By in previous query
--WITH PopVsVac AS
--(
--SELECT dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
--  SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
--FROM `covid-da-case-study.covid_data.covid_deaths` AS dea
--JOIN `covid-da-case-study.covid_data.covid_vaccinations` AS vac
--  ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--)
--SELECT *, (RollingPeopleVaccinated/Population)*100 AS VaccinationRate
--FROM PopVsVac
--ORDER BY 2,3;
