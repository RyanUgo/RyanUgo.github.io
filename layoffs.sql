--data cleaning
--we'll be working on
--1. remove duplicate
--2. standardizze the duplicate
--3. null value or blak values
-- 4. remove any columns


select *
from world_layoff..layoffs

--this creates or copies the date of a previous table into a new table


select *
from layofffs_staging;

alter table world_layoff..layoffs
drop column layoff_date;

alter table layofffs_staging
drop column layoff_date;


insert layofffs_staging
select *
from world_layoff..layoffs;


--1. removing duplicate

select *,
row_number() over (
PARTITION by company, industry, total_laid_off, percentage_laid_off, 'date' order by company) as row_num
from layofffs_staging;

with duplicate_cte as (
select *,
row_number() over (
PARTITION by company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions order by company) as row_num
from layofffs_staging
)
select *
from duplicate_cte
where row_num>1;


select *
from layofffs_staging
where company = '#paid';


with duplicate_cte as (
select *,
row_number() over (
PARTITION by company,location, industry, total_laid_off, percentage_laid_off, 'date', stage,
country, funds_raised_millions order by company) as row_num
from layofffs_staging
)
delete 
from duplicate_cte
where row_num>1;

select *,
row_number() over (
PARTITION by company, industry, total_laid_off, percentage_laid_off, 'date' order by company) as row_num
from layofffs_staging;


select *
into  layofffs_staging2
from layofffs_staging
where 1=0;

select *
from layofffs_staging2

alter table layofffs_staging2
add  row_num int

alter table layofffs_staging2
drop column row_num

select *
from layofffs_staging2

select *,
row_number() over (
PARTITION by company, industry, total_laid_off, percentage_laid_off, 'date' order by company) as row_num
from layofffs_staging2;

with duplicate_cte as (
select *,
row_number() over (
PARTITION by company,location, industry, total_laid_off, 
percentage_laid_off, 'date', stage, country, funds_raised_millions order by company) as row_num
from layofffs_staging2
)
select *
from duplicate_cte
where row_num>1;


with duplicate_cte as (
select *,
row_number() over (
PARTITION by company,location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised_millions order by company) as row_num
from layofffs_staging2
)
delete 
from duplicate_cte
where row_num>1;

select *,
row_number() over (
PARTITION by company,location, industry, total_laid_off, 
percentage_laid_off, 'date', stage, country, funds_raised_millions order by company) as row_num
from layofffs_staging2





insert into layofffs_staging2
select *
from layofffs_staging





---standardizing data means finding space in your data and deleting it

select company, trim(company),
row_number() over (
PARTITION by company, industry, total_laid_off, percentage_laid_off, 'date' order by company) as row_num
from layofffs_staging2;


select company, trim(company) as Trimmedcompany
from layofffs_staging2

update layofffs_staging
set company=trim(company);

select distinct industry
from layofffs_staging2
order by 1;

select distinct industry
from layofffs_staging2
where industry like 'Crypto%';

update layofffs_staging2
set industry='Crypto'
where industry Like 'Crypto%'

select distinct country
from layofffs_staging2
where country like 'United State%'

select distinct country, trim(trailing '.' from country)
from layofffs_staging2
order by 1;

update layofffs_staging2
set country=trim(trailing '.' from country)
where country like 'United States%'

select *
from layofffs_staging2
where industry is null
or industry=' ';

select *
from layofffs_staging2
where company='Airbnb'

select t1.industry, t2.industry
from layofffs_staging2 t1
join layofffs_staging2 t2
on t1.company=t2.company
and t1.location=t2.location
where t1.industry is null
and t2.industry is not null


update  layofffs_staging2 
join layofffs_staging2 t2-- didn't work properly
on t1.company=t2.company-- didn't work properly
set t1.industry = t2.industry-- didn't work properly
where t1.industry is null-- didn't work properly
and t2.industry is not null;   -- didn't work properly

select *
from layofffs_staging2
where total_laid_off is null
and percentage_laid_off is null


delete
from layofffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select *
from layofffs_staging2
