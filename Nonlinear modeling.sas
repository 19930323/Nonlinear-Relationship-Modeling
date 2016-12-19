/* Generated Code (IMPORT) */
/* Source File: Tree.xls */
/* Source Path: /folders/myshortcuts/myfolder */
/* Code generated on: 12/5/16, 10:38 PM */

%web_drop_table(WORK.IMPORT);


FILENAME REFFILE '/folders/myshortcuts/myfolder/Tree.xls';

PROC IMPORT DATAFILE=REFFILE
	DBMS=XLS
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.IMPORT; RUN;


%web_open_table(WORK.IMPORT);
options nocenter nodate pageno=1 ls=76 ps=45 nolabel;
proc print data=work.import;
run;
data all;
set work.import;
run;
proc means n mean median std min max css uss maxdec=4 data=all;
var DBH HT;
run;
*******************************************************
*plot of tree total height (HT) against diameter (DBH)*
*******************************************************;
proc plot;
plot HT*DBH='*';
run;
data all;
set all;
HTmax=200;
exp=1/(-log(HT/HTmax));
lundqvist = log(-log(HT/HTmax));
logistic=log((HTmax/HT)-1);
richards=log(1-(HT/HTmax));
weibull=log(-log(1-(HT/HTmax)));
lnDBH=log(DBH);
run; 
***********************************************
*estimating initial values of model parameters*
***********************************************;
proc reg data=all;
model exp=DBH;
model lundqvist=lnDBH;
model logistic=DBH;
model richards=DBH/noint;
model weibull=lnDBH;
run;

**********************
*Exponential function*
**********************;
proc nlin data=all method= MARQUARDT list;
parms a=200 b=9 c=0.07;
model HT=a*exp(-b/(DBH+c));
output out=out11 p=predict r=residual;
proc nlin data=all method=Gauss list;
parms a=200 b=9 c=0.07;
model HT=a*exp(-b/(DBH+c));
output out=out12 p=predict r=residual;
proc nlin data=all method=NEWTON list;
parms a=200 b=9 c=0.07;
model HT=a*exp(-b/(DBH+c));
output out=out13 p=predict r=residual;
proc plot data=out11;
plot residual*predict='*'/vref=0;
plot predict*DBH='*' HT*DBH='#'/overlay;
title 'Exp function';
run;

********************
*Lundqvist Function*
********************;
proc nlin data=all method=GAUSS list;
parms a=200 b=2 c=0.5;
model HT =a*exp(-b*DBH**(-c));
output out=out21 p=predict r=residual;
proc nlin data=all method=MARQUARDT list;
parms a=200 b=2 c=0.5;
model HT =a*exp(-b*DBH**(-c));
output out=out22 p=predict r=residual;
proc nlin data=all method=NEWTON list;
parms a=200 b=2 c=0.5;
model HT =a*exp(-b*DBH**(-c));
output out=out23 p=predict r=residual;
proc plot data=out21;
plot residual*predict='*'/vref=0;
plot predict*DBH='*' HT*DBH='#'/overlay;
title 'Lundqvist function';
run;

****************************
*Modified logistic function*
****************************;
title 'Modified Logistic Function';
proc nlin data=all method=Gauss list;
parms a=60 b=0.1 c=2;
model HT=a/(1+((1/b)*DBH**-c));
output out=out31 p=predict r=residual;
proc nlin data=all method=MARQUARDT list;
parms a=60 b=0.1 c=2;
model HT=a/(1+((1/b)*DBH**-c));
output out=out32 p=predict r=residual;
proc nlin data=all method=NEWTON list;
parms a=60 b=0.1 c=2;
model HT=a/(1+((1/b)*DBH**-c));
output out=out33 p=predict r=residual;
proc plot data=out31;
plot residual*predict='*'/vref=0;
plot predict*DBH='*' HT*DBH='#'/overlay;
title 'Modified Logistic function';
run;

*******************
*Richards function*
*******************;
proc nlin data=all method=Gauss list;
parms a=200 b=0.04 c=1;
model HT=a*(1-exp(-b*DBH))**c;
output out=out41 p=predict r=residual;
proc nlin data=all method=MARQUARDT list;
parms a=200 b=0.04 c=1;
model HT=a*(1-exp(-b*DBH))**c;
output out=out42 p=predict r=residual;
proc nlin data=all method=NEWTON list;
parms a=200 b=0.04 c=1;
model HT=a*(1-exp(-b*DBH))**c;
output out=out43 p=predict r=residual;
proc plot data=out41;
plot residual*predict='*'/vref=0;
plot predict*DBH='*' HT*DBH='#'/overlay;
title 'Richards function';
run;

******************
*Weibull function*
******************;
proc nlin data=all method=Gauss list;
parms a=200 b=0.01 c=1.5;
model HT=a*(1-exp(-b*DBH**c));
output out=out51 p=predict r=residual;
proc nlin data=all method=MARQUARDT list;
parms a=200 b=0.01 c=1.5;
model HT=a*(1-exp(-b*DBH**c));
output out=out52 p=predict r=residual;
proc nlin data=all method=NEWTON list;
parms a=200 b=0.01 c=1.5;
model HT=a*(1-exp(-b*DBH**c));
output out=out53 p=predict r=residual;
proc plot data=out51;
plot residual*predict='*'/vref=0;
plot predict*DBH='*' HT*DBH='#'/overlay;
title 'Weibull function';
run;

************
*Simulation*
************;
data all;
set all;
exp=229.3*exp(-16.8873/(DBH+4.1700));
lundqvist=491.0*exp(-4.6627*DBH**(-0.3854));
logistic=226.6/(1+(1/0.0311)*DBH**(-1.1614));
richards=179.0*(1-exp(-0.0525*DBH))**(1.0499);
weibull=176.8*(1-exp(-0.0453*DBH**1.0442));
run;

PROC PRINT DATA=all;
   VAR HT DBH exp lundqvist logistic richards weibull;
RUN;



DATA new;
DO DBH = 1,2,3,4,5 TO 85 BY 1;
exp=229.3*exp(-16.8873/(DBH+4.1700));
lundqvist=491.0*exp(-4.6627*DBH**(-0.3854));
logistic=226.6/(1+(1/0.0311)*DBH**(-1.1614));
richards=179.0*(1-exp(-0.0525*DBH))**(1.0499);
weibull=176.8*(1-exp(-0.0453*DBH**1.0442));
output;
end;
run;
PROC PRINT DATA=new;
   VAR DBH exp lundqvist logistic richards weibull;
RUN;

DATA new;
DO DBH = 81 TO 82 BY 0.1;
exp=229.3*exp(-16.8873/(DBH+4.1700));
lundqvist=491.0*exp(-4.6627*DBH**(-0.3854));
logistic=226.6/(1+(1/0.0311)*DBH**(-1.1614));
richards=179.0*(1-exp(-0.0525*DBH))**(1.0499);
weibull=176.8*(1-exp(-0.0453*DBH**1.0442));
output;
end;
run;
PROC PRINT DATA=new;
   VAR DBH exp lundqvist logistic richards weibull;
RUN;
