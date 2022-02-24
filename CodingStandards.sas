%macro count_obs(dataset);
	%let dataset_id = %sysfunc(open(&dataset., IN));
	%let NOBS = %sysfunc(attrn(&dataset_id., NOBS));
	%let RC = %sysfunc(close(&dataset_id.));
	&nobs;
%mend;


%let N = 1000;
%let mu = 0;
%let sigma = 1;
%let lambda = 8;

* standard normal distribution;

data tmp(keep=x y z w i);
do i = 0 to &N by 0.01;
	x = 1/&lambda * rand("Exponential");
	y = rand("Uniform");
	z = rand("Normal");
	w = rand("Normal", &mu, &sigma);
	output;
end;
run;

%let tmp_nobs = %count_obs(dataset=work.tmp);
%put &=tmp_nobs;

* create short version of work.tmp dataset;
* for printing;
data tmp_short;
set work.tmp(obs=1000);
rename x = Exponentinal
		y = Uniform
		z = Normal
		w = Standard_Normal;
run;

proc sgplot data=work.tmp_short;
scatter x=i y=Standard_Normal;
run;

proc means data=work.tmp; run;
proc print data=work.tmp_short; run;
***************************************************************************;
data pool;
set sashelp.electric;
run;

proc sql;
create table customer_pool
as select Customer, sum(Revenue) as Sum_Revenue
from work.pool
group by Customer
order by Sum_Revenue desc;
run;

proc print data=work.customer_pool; run; 
***** create generalized linear regression model from work.pool;

proc sql;
create table max_revenue_by_year
as select year, max(Revenue) as Max_Revenue
from work.pool
group by year
order by Max_Revenue desc;
run;

proc print data=work.max_revenue_by_year; run;

proc sgplot data=work.pool;
scatter x=Customer y=Revenue;
scatter x=Year y=Revenue;
run;

proc sgplot data=work.max_revenue_by_year;
scatter x=Year y=Max_Revenue;
run;

proc genmod data=work.pool plots=all;
class Customer;
model Revenue = Customer Year /
	dist=normal
	link=identity;
run;

proc genmod data=work.max_revenue_by_year;
model Max_Revenue = Year /
	dist=poisson
	link=log;
run;


