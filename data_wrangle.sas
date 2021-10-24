libname mydir '/home/u59308798/BUMK742/Project 1';


data shawty;          
set mydir.tropic;     /* load the SAS data file 'tropic.sas7bdat' */



/* Create log-transformation of sales and price */
lq=log(quant);
lp=log(price);

/* Create three dummy variables for the four quarters */
/* treating the fourth quarter as the baseline */
qrt1=0;
qrt2=0;
qrt3=0;
if (week>=1 and week<=13) or (week>=53 and week<=65) then qrt1=1;
if (week>=14 and week<=26) or (week>=66 and week<=78) then qrt2=1;
if (week>=27 and week<=39) or (week>=79 and week<=91) then qrt3=1;
if store=2 then store1=1 ; else if store1=. then store1=0;
if store=14 then store2=1; else if store2=. then store2=0;
if store=32 then store3=1; else if store3=. then store3=0;
if store=52 then store4=1; else if store4=. then store4=0;
if store=62 then store5=1; else if store5=. then store5=0;
if store=68 then store6=1; else if store6=. then store6=0;
if store=71 then store7=1; else if store7=. then store7=0;
if store=72 then store8=1; else if store8=. then store8=0;
if store=93 then store9=1; else if store9=. then store9=0;
if store=95 then store10=1; else if store10=. then store10=0;
if store=111 then store11=1; else if store11=. then store11=0;
if store=123 then store12=1; else if store12=. then store12=0;
if store=124 then store13=1; else if store13=. then store13=0;
if store=130 then store14=1; else if store14=. then store14=0;
chprc=put(price,4.2);
if substr(chprc,4,1)="9" then end9=1;
else end9=0;
run;


proc means data=shawty;
run;

/* Estimate alternative models in the following proc reg statement */
proc reg;
model quant=store1-store14 price deal end9 week qrt1-qrt3 ;

model lq=store1-store14 lp deal end9 week qrt1-qrt3;

model lq=store1-store14 price deal end9 week qrt1-qrt3;
run; 

proc means data=shawty;
run;