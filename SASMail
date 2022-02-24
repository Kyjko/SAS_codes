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


data tmp;
do x = -100 to 100 by 1;
	y = x*x;
	output;
end;
run;

%let N = 1000;
data tmp2(keep=x y z w);
call streaminit(65734);
lambda = 5;
mu = 2;
sigma = 3;
do i = 1 to &N;
	x = 1/lambda * rand("Exponential");
	y = rand("Uniform");
	z = rand("Normal");
	w = rand("Normal", mu, sigma);
	output;
end;
run;

ods html file="/home/u60648081/tmp2.html";
title "random variables";
proc print data=work.tmp2; run;
ods html close;

%sasmail(to="josad91795@shackvine.com", su="DO NOT REPLY - SAS", at="/home/u60648081/tmp2.html");

proc sgplot data=work.tmp;
	series x=x y=y;
run;

ods html file="/home/u60648081/tmp.html";
title "Quadratic function";

proc print data=work.tmp;
	id x;
	var y;
run;

ods html close;

%sendmail();
