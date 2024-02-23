use [Portfolio_Project];
select * from coviddeath order by 1,2 ;
select location,total_cases,total_deaths from coviddeath where location='Afghanistan';
select * from CovidVaccinations;

	--total deaths percent as per cases in India
	select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage 
	from coviddeath
	where location LIKE '%India'
	order by 1,2;
	--total cases based on population in India
	select location,date,population,total_cases,(total_cases/population)*100 as Cases_Percentage
	from coviddeath
	where location LIKE '%India'
	order by 1,2;
	--continents with highest cases as per their population
	select continent, MAX(total_cases) as Top_Cases from coviddeath
	where continent is not null
	group by continent order by sum(population)DESC;

	--countries with highest death count per population
	select location,MAX((total_deaths/population))*100 as Highest_Deaths from coviddeath
	where continent is not null
	group by location order by 1,2;
	--new cases in the year 2021
	select date,continent,new_cases from coviddeath
	where date between '2021-01-01' and '2021-12-31' and continent is not null
	order by date,continent,new_cases;	
	--join covid death and covid vaccine table
	select * from coviddeath;
	select * from CovidVaccinations;

	select dea.continent,dea.location 
	from coviddeath dea
	join CovidVaccinations vac
	on dea.date=vac.date;

	--Average people who are fully vaccinated
	select dea.location,avg(cast(vac.people_fully_vaccinated as float)) as AverageVaccinations
	from coviddeath dea
	join CovidVaccinations vac
	on dea.date=vac.date
	where dea.location is not null
	group by dea.location
	order by dea.location;

	--vaccinations based on population
	select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
	
	from coviddeath dea
	join CovidVaccinations vac
	on dea.date=vac.date
	where dea.continent is not null
--view

create view sample_view as
select dea.location,avg(cast(vac.people_fully_vaccinated as float)) as AverageVaccinations
	from coviddeath dea
	join CovidVaccinations vac
	on dea.date=vac.date
	where dea.location is not null
	group by dea.location
	--order by dea.location;