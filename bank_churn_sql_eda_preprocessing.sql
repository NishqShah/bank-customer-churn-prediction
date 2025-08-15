## Customer Churn Prediction
use project;
create table churn(
RowNumber int,
CustomerId  bigint,
Surname varchar(50),
CreditScore int,
Geography   varchar(50),
Gender  varchar(10),
Age int,
Tenure  int,
Balance decimal(15,2),
NumOfProducts int,
HasCrCard   int,
IsActiveMember  int,
EstimatedSalary decimal(15,2),
Exited  int,
Complain int,
Satisfaction_Score int,
Card_Type varchar(20),
Point_Earned int
);

select * from churn;

## Preprocessing in SQL

alter table churn
drop column RowNumber,
drop column CustomerID,
drop column Surname;

alter table churn add column Gender_code int;
update churn
set Gender_Code = case
    when Gender = 'Male' then 1
    when Gender = 'Female' then 0
end;

alter table churn
add column Geo_France int,
add column Geo_Spain int,
add column Geo_Germany int;

update churn
set Geo_France  = case when Geography = 'France' then 1 else 0 end,
    Geo_Spain   = case when Geography = 'Spain'  then 1 else 0 end,
    Geo_Germany = case when Geography = 'Germany' then 1 else 0 end;

alter table churn
add column Card_Gold int,
add column Card_Silver int,
add column Card_Platinum int,
add column Card_Diamond int;

update churn
set Card_Gold  = case when Card_type = 'Gold' then 1 else 0 end,
    Card_Silver   = case when Card_type = 'Silver'  then 1 else 0 end,
    Card_Platinum = case when Card_type = 'Platinum' then 1 else 0 end,
    Card_Diamond  = case when Card_type = 'Diamond' then 1 else 0 end;

alter table churn add column age_group varchar(20);

update churn
set age_group = case
when Age < 30 then 'Young'
when age between 30 and 50 then 'Middle'
else 'Senior'
end;

select
sum(case when CreditScore is null then 1 else 0 end) as null_creditscore,
sum(case when Geography is null then 1 else 0 end) as null_geography,
sum(case when Gender is null then 1 else 0 end) as null_gender,
sum(case when Age is null then 1 else 0 end) as null_age,
sum(case when Balance is null then 1 else 0 end) as null_balance,
sum(case when NumOfProducts is null then 1 else 0 end) as null_numofproducts,
sum(case when HasCrCard is null then 1 else 0 end) as null_hascrcard,
sum(case when IsActiveMember is null then 1 else 0 end) as null_isactivemember,
sum(case when EstimatedSalary is null then 1 else 0 end) as null_estimatedsalary,
sum(case when Exited is null then 1 else 0 end) as null_exited
from churn;


##SQL EDA
select * from churn;

/* Overview of Dataset */
select count(*) as customers
from churn;

/*Churn vs ACtive Customers */
select
sum(Exited) as  churn_customers,
count(*) - sum(Exited) as active_customers,
count(*) as total_customers,
round(sum(Exited) * 100 / count(*),2) as churn_rate
from churn;

/*Churn rate by Geography */

select
Geography,
sum(Exited) as churn_customers,
count(*) as total_customers,
round(sum(Exited) * 100 / count(*),2) as churn_rate
from churn
group by Geography
order by churn_rate desc;

/*Churn Rate by Gender */

select
Gender,
sum(Exited) as churn_customers,
count(*) as total_customers,
round(sum(Exited) * 100 / count(*),2) as churn_rate
from churn
group by Gender
order by churn_rate desc;

/*Churn by Age Group*/

select
age_group,
sum(Exited) as churn_customers,
count(*) as total_customers,
round(sum(Exited) * 100 / count(*),2) as churn_rate
from churn
group by age_group
order by churn_rate desc;

/*Churn Rate by Number of Products*/

select
NumOfProducts,
sum(Exited) as churn_customers,
count(*) as total_customers,
round(sum(Exited) * 100 / count(*),2) as churn_rate
from churn
group by NumOfProducts
order by churn_rate desc;

/*Churn Rate by Activity Status*/

select
IsActiveMember,
sum(Exited) as churn_customers,
count(*) as total_customers,
round(sum(Exited) * 100 / count(*),2) as churn_rate
from churn
group by IsActiveMember
order by churn_rate desc;

/*Average Credit Score by Churn Status*/
select
Exited,
round(avg(CreditScore),2) as avg_credit_score
from churn
group by Exited;

/*Average Balance by Churn Status*/
select
Exited,
round(avg(Balance),2) as avg_balance
from churn
group by Exited;

/* Top 10 High Balance Churned Customers*/
select
Geography,Gender,Age,Balance,NumOfProducts,EstimatedSalary
from churn
where Exited = 1
order by Balance Desc
limit 10;
