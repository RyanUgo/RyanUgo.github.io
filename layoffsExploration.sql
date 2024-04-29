--Exploratory data analysis

select *
from layofffs_staging2;

select max(total_laid_off), max(percentage_laid_off)
from layofffs_staging2;

select *
from layofffs_staging2
where percentage_laid_off=1
order by total_laid_off desc;

select company, sum(total_laid_off)
from layofffs_staging2
group by company
order by 2 desc;

select min(date), max(date)
from layofffs_staging2;

select industry, sum(total_laid_off)
from layofffs_staging2
group by industry
order by 2 desc;

select *
from layofffs_staging2;

select country, sum(total_laid_off)
from layofffs_staging2
group by country
order by 2 desc;

select year(date), sum(total_laid_off)
from layofffs_staging2
group by year(date)
order by 2 desc;

select stage, sum(total_laid_off)
from layofffs_staging2
group by stage
order by 2 desc;

select company, avg(percentage_laid_off)
from layofffs_staging2
group by company
order by 2 desc;


select company, year(date), sum(total_laid_off)
from layofffs_staging2
group by company, year(date)
order by company asc;

select company, year(date), sum(total_laid_off)
from layofffs_staging2
group by company, year(date)
order by 3 desc;

with company_year (company, years, total_laid_off) as
(
select company, year(date), sum(total_laid_off)
from layofffs_staging2
group by company, year(date)
), company_year_rank as
(select *, DENSE_RANK() over (partition by years order by total_laid_off desc) as ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5
;