--Entire tables in DB

select * from hrdata


--KPI (Employee Count)

select sum(employee_count) as Employee_count from hrdata
--where education = 'High School'
--where department = 'Sales'
where education_field = 'Medical'


--KPI (Attrition Count)

select count(attrition) as Attrition_count from hrdata
where attrition = 'Yes' and education = 'Doctoral Degree' and education_field = 'Medical'

select count(attrition) as Attrition_count from hrdata
where attrition = 'Yes' and department = 'Sales' and education_field = 'Medical'

select count(attrition) as Attrition_count from hrdata
where attrition = 'Yes' and department = 'R&D' and education_field = 'Medical' and education = 'High School'


--KPI (Attrition Rate)

select round(((select count(attrition) as Attrition_count from hrdata where attrition = 'Yes')/sum(employee_count))*100,2) from hrdata

--KPI (Active Employees)

select sum(employee_count) - (select count(attrition) from hrdata where attrition = 'Yes' and gender = 'Male')
from hrdata where gender = 'Male'

--KPI (Average Age)

select avg(age) from hrdata

select round(avg(age)) as Average_age from hrdata



-- Attrition by Gender

select gender, count(attrition) from hrdata 
where attrition = 'Yes'
group by gender
--order by gender desc
order by count(attrition) desc
--order by count(attrition) asc

select gender, count(attrition) from hrdata 
where attrition = 'Yes' and education = 'High School'
group by gender
order by gender desc

select gender, count(attrition) from hrdata 
where attrition = 'Yes' and education_field = 'Medical'
group by gender
order by gender desc


-- Department wise Attrition

select department, count(attrition) from hrdata where attrition = 'Yes'
group by department
order by department asc


select department, count(attrition) from hrdata 
where attrition = 'Yes' and education_field = 'Medical'
group by department
order by count(attrition) desc

-- for percentage (attrition/total attrition)
select department, count(attrition),
round((cast(count(attrition) as numeric)
	  /(select count(attrition) from hrdata where attrition = 'Yes'  and gender = 'Female'))*100,2) as pct
from hrdata 
where attrition = 'Yes' and gender = 'Female'
group by department
order by count(attrition) desc



-- No of Employee by Age Group

select sum(employee_count), age 
from hrdata 
where department = 'R&D'
group by age
order by age



-- Education Field wise Attrition

select education_field, count(attrition) from hrdata 
where attrition = 'Yes' 
group by education_field
order by count(attrition) desc


-- Attrition Rate by Gender for different Age group

select age_band, gender, count(attrition) from hrdata 
where attrition = 'Yes'
group by age_band, gender
order by age_band, gender

select gender, count(attrition) from hrdata 
where attrition = 'Yes' and age_band ='Under 25'
group by gender

select gender, count(attrition) from hrdata 
where attrition = 'Yes' and age_band = '25 - 34'
group by gender

-- for Percentage

select age_band, gender, count(attrition), 
round((cast(count(attrition) as numeric) /
	(select count(attrition) from hrdata where attrition = 'Yes'))*100,2) as pct
from hrdata  
where attrition = 'Yes'
group by age_band, gender
order by age_band, gender

 

-- Job Satisfaction Rating

create extension if not exists tablefunc;

Select * from crosstab(
'select job_role, job_satisfaction, sum(employee_count) from hrdata
group by job_role, job_satisfaction
order by job_role, job_satisfaction') as ct (job_role varchar(50), one numeric, two numeric, three numeric, four numeric)
					   
					   
