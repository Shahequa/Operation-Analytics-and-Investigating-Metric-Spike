create database operation_analytics;

use operation_analytics;

/*Case Study 1 (Job Data)*/

create table job_data(
job_id int,
actors_id int,
event varchar(255),
language varchar(255),
time_spent int,
org varchar(255),
ds date);

select * from job_data;

INSERT INTO job_data (ds, job_id, actor_id, event, language, time_spent, org)
VALUES ('2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
       ('2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
       ('2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
       ('2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
       ('2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
       ('2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
       ('2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
       ('2020-11-25', 20, 1004, 'transfer', 'Italian', 45, 'C');

    
/*Number of jobs reviewed: Amount of jobs reviewed over time.
Your task: Calculate the number of jobs reviewed per hour per day for November 2020?*/

select 
count(distinct job_id)/(30*24) as num_jobs_reviewed
from job_data
where 
ds between '2020-11-01' and '2020-11-30';

/*Throughput: It is the no. of events happening per second.
Your task: Let’s say the above metric is called throughput. 
Calculate 7 day rolling average of throughput? 
For throughput, do you prefer daily metric or 7-day rolling and why?*/

select ds, 
       jobs_reviewed,
       avg(jobs_reviewed)over(order by ds rows between 6 preceding and current row) as throughput_7
from
(
select ds, count(distinct job_id) as jobs_reviewed
from job_data
where ds between '2020-11-01' and '2020-11-30'
group by ds
)a;

/*Percentage share of each language: Share of each language for different contents.
Your task: Calculate the percentage share of each language in the last 30 days?*/

select language,
num_jobs,
100.0* num_jobs/total_jobs as pct_share_lang
from
(
select language, count(distinct job_id) as num_jobs
from job_data
group by language
)a
cross join
(
select count(distinct job_id) as total_jobs 
from job_data
)b;

/*Duplicate rows: Rows that have the same value present in them.
Your task: Let’s say you see some duplicate rows in the data. 
           How will you display duplicates from the table?*/

select * from
(
select *,
row_number()over(partition by job_id) as rownum 
from job_data
)a 
where rownum>1;