%macro sasmail(to=, su=, at=);
filename outbox EMAIL;
data _null_;
	FILE outbox
	to=&to.
	from="noreply-sastest@sastest.org"
	subject=&su.
	attach=&at.;
	file outbox;
	put "report, do not reply!";
	put "thanks";
run;
%mend;

%let homedir = /home/u60648081/;

data pool;
set sashelp.heart(obs=1000);
run;

*******************************;
*proc means data=work.pool; *run;
*proc print data=work.pool; *run;
*******************************;

title "T-Test for assessing differences in Cholesterol level by Status";
proc ttest data=work.pool;
class Status;
var Cholesterol;
run;

ods pdf file="&homedir.ttest_bloodpressure.pdf";
title "T-Test for assessing differences in Diastolic and Systolic blood pressure by Sex";
proc ttest data=work.pool;
class Sex;
var Diastolic Systolic;
run;
ods pdf close;
