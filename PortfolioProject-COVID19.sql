--outputs coviddeaths table ordered by location, date
select * from portfolioproject..coviddeaths
order by 3,4

--outputs covidvaccinations table ordered by location, date
select * from portfolioproject..covidvaccinations
order by 3,4

select location, date, total_cases, new_cases, total_deaths, population
from portfolioproject..coviddeaths
order by 1,2

--outputs daily death rate calculated as total_death / total_cases in Canada
select location, date, total_cases, total_deaths, total_deaths / total_cases * 100 as death_percentage
from portfolioproject..coviddeaths
where location = 'canada'
order by 1,2

--outputs the percentage of covid cases per country population calculated as total cases vs population (total cases / population)
select location, date, total_cases, population, total_cases / population * 100 as infected_percentage
from portfolioproject..coviddeaths
where location = 'canada'
order by 1,2

--outputs countries with highest DAILY infection rate compared to population in descending order
select location, population, max(total_cases) as max_total_cases, max(total_cases / population) * 100 as infected_percentage
from portfolioproject..coviddeaths
group by location, population
order by infected_percentage desc
--Canada ranks 90 with 4.11% DAILY infection rate over population

--outputs countries with highest death count in descending order
select location, population, max(cast(total_deaths as int)) as total_deaths
from portfolioproject..coviddeaths
where continent is not null
group by location, population
order by total_deaths desc
--Canada ranks 22 with 8554993 total deaths.

--outputs covid info date between '2021-06-15' and '2021-09-15'
select * from portfolioproject..coviddeaths
where location = 'canada'
and date between '2021-06-15' and '2021-09-15'

--continents with the highest death rate 
select continent, max(cast(total_deaths as int)) as total_deaths
from portfolioproject..coviddeaths
where continent is not null
group by continent
order by total_deaths desc



--NOW VACCINATIONS in CANADA
select * from portfolioproject..CovidVaccinations

--JOINING TWO TABLES using location and date columns
select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
sum(cast(new_vaccinations as int)) over (partition by cd.location order by cd.location) as total_vac
from portfolioproject..CovidDeaths cd
join portfolioproject..CovidVaccinations cv
on cd.location = cv.location
and cd.date = cv.date
where cd.continent is not null
order by 2,3
