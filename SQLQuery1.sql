-- this will show the likelyhood of dying if you contract covid in your country
select Location , date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
from project..coviddeaths
where location = 'United States'
order by 1, 2

--the total cases vs population
select Location , date, total_cases, Population, (total_cases/Population)*100 as death_percentage
from project..coviddeaths
--where location = 'United States'
order by 1, 2



--Countries with highest infection rates

select Location , Population, max(total_cases) as highestinfectioncount, max((total_cases/Population))*100 as infected_population_percentage
from project..coviddeaths
--where location = 'United States'
group by Population, Location
order by infected_population_percentage desc


--countries with highest death count

select Location , max(cast(total_deaths as int)) as totaldeathcount
from project..coviddeaths
--where location = 'United States'
where continent is not null
group by Location
order by totaldeathcount desc


-- continents wuith the highest death count 

select continent , max(cast(total_deaths as int)) as totaldeathcount
from project..coviddeaths
--where location = 'United States'
where continent is not null
group by continent
order by totaldeathcount desc



-- Global numbers

select datE, SUM(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from project..coviddeaths
--ere Location = 'United States'
where continent is not null
group by date
order by 1, 2


--total population vs vaccition

with PopvsVacc (continent, location, date, population, new_vaccinations, totalpeoplevacc)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as totalpeoplevacc
from project..coviddeaths dea
join project..covidvacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (totalpeoplevacc/population)*100
from PopvsVacc


-- creating view for visualization

create view percentagepopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as totalpeoplevacc
from project..coviddeaths dea
join project..covidvacc vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3