%macro count_obs(dataset);
	%let dataset_id = %sysfunc(open(&dataset., IN));
	%let NOBS = %sysfunc(attrn(&dataset_id., NOBS));
	%let RC = %sysfunc(close(&dataset_id.));
	&nobs;
%mend; 

%macro calc_mean(dataset, ivar);
	title "mean analysis of &ivar";
	proc means data=&dataset.;
		var &ivar.;
		output mean=;
	run;
%mend;

data tmppool;
set sashelp.heart;
run;

%calc_mean(work.tmppool, Diastolic);
%calc_mean(work.tmppool, Systolic);
%calc_mean(work.tmppool, AgeAtStart);
%calc_mean(work.tmppool, Weight);

%macro plot(dataset=, type=, xvar=, yvar=);
	proc sgplot data=&dataset.;
	&type. x=&xvar. y=&yvar.;
	run;
%mend;

data pool;
set sashelp.fish;
if weight ne .;
run;

%let N_OBS = %count_obs(work.pool);
%put &=N_OBS;

%let N_OBS_UNFILTERED = %count_obs(sashelp.fish);
%put &=N_OBS_UNFILTERED;

title "plot";
proc sgplot data=work.pool;
scatter x=Width y=Height;
run;

proc sgplot data=work.pool;
hbox Width; 
hbox Height;
run;

proc corr data=work.pool;
var Height;
with Width;
run;

%plot(dataset=work.pool, type=scatter, xvar=Height, yvar=Width);
