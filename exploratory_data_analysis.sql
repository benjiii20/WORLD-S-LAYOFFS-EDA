#Exploratory Data Analysis

select*
from layoffs_staging2;

#work with total_laid_off 

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

select*
from layoffs_staging2
where percentage_laid_off = 1 
order by funds_raised_millions desc
;


select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc
;

select min(`date`), max(`date`)
from layoffs_staging2
;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc
;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc
;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc
;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc
;


# monthly Rolling sum of the layoff

select substring(`date`, 1, 7) as `Month`, sum(total_laid_off)
#just to take the month from the date
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `Month`
order by 1 asc;

with Rolling_Total as
(
select substring(`date`, 1, 7) as `Month`, sum(total_laid_off) as total_off
from layoffs_staging2
where substring(`date`, 1, 7) is not null
group by `Month`
order by 1 asc
)
select `Month`, total_off , sum(total_off) over(order by `Month`) as rolling_total
from Rolling_Total
;


#Company's layoff in a year


select company,year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company ,year(`date`)
order by 3 desc
;



#Rank which year they laidoff the most employees by company

with company_year as
(
select company,
year(`date`) as years, 
sum(total_laid_off) as laid_off
from layoffs_staging2
group by company ,year(`date`)
) , company_year_rank as
(
select*,
dense_rank() over(partition by years order by laid_off desc) as ranking
from company_year
where years is not null
)
select*
from company_year_rank
where ranking<=5
;



