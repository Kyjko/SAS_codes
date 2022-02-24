data pool;
set sashelp.heart;
run;

proc print data=pool; run;

proc genmod data=pool plots=all;
class Sex Smoking_Status BP_Status Status;
model Status = Sex Smoking_Status AgeAtStart Weight Height Diastolic Systolic MRW Smoking_Status Cholesterol BP_Status /
	 dist = binomial
	 link = logit
	 type1
	 type3;
run;

* ---------excercise-----------------------;

proc freq data=work.pool; 
table Weight_Status * BP_Status;
run;

proc corr data=work.pool;
var Diastolic;
with Systolic;
run;
