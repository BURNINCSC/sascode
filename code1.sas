/*Airbnb is an online marketplace to offer accommodation sharing.*/ 
/*The hosts offer their homes on the site to provide lodging services to tourists or other travel guests. */
/*We are interested in understanding the listing activities in New York City in 2019.*/

/*The data I'm going to use are stored in two files:*/
/*(1) File “MainListings.sas7bdat” contains the main characteristics of the listed units*/

/*(2) File “Reviews.sas7bdat” contains the number of customer reviews.*/

/*MainListings.sas7bdat (N = 45,094) observations 7 variables)*/
/* Variable name    Type        Description */

/* id               Numeric      The identifier for each listing unit (i.e., a home)*/
/* name             Character    A short description of the home*/ 
/* host_id      	Character    The identifier for host borough Numeric New York encompasses five administrative divisions (called boroughs)*/ 
						       /*1=(Bronx)*/  
						  	   /*2=(Brooklyn)*/  
						  	   /*3=(Manhattan)*/  
						 	   /*4=(Queens)*/  
							   /*5=(Staten Island)*/  
/* neighbourhood    Character    The name of neighborhood*/
/* room_type        Numeric      The type of dwelling*/
						 	   /*1=(Entire home/apartment)*/  
						  	   /*2=(Private room)*/  
						  	   /*3=(Shared room) price*/  
/* Price	        Numeric      Price in dollars*/ 
/* logPrice         Numeric    	 logPrice=log(Price)*/

/* Reviews.sas7bdat (N=49,077 observations2 variables)*/
/* Variable name      Type       Description*/

/* id                 Numeric    The identifier for each listing unit (i.e., a home)*/ 
/* number_of_reviews  Numeric 	  The number of reviews each listing received*/
			               	  /*-999=Missing (note that 0 is NOT a missing value)*/
			               	  
			               	  
			               	
/*Merge MainListings.sas7bdat with Reviews.sas7bdat and keep all the listings that appear in the MainListings dataset. That is, do NOT add the listings that appear only in the Reviews dataset. You may name the new file “combined”.*/ 
/*Recode variable “price” into missing (.) if price is strictly larger than 5000 (i.e., price>5000).*/
/*For variable “number_of_reviews”, recode -999 into missing.*/
/*Keep only the observations where variable “borough” is not missing and variable “room_type” is not missing.*/
	
libname mydata '/home/u59308798/BUMK726/Midterm';

data work.mainlistings;
	set mydata.mainlistings;
run;

data work.reviews;
	set mydata.reviews;
run;

proc sort data=mainlistings;
	by id;
run;

proc sort data=reviews;
	by id;
run;

data Combined;
	merge mainlistings(in=inA) reviews(in=inB);
	by id;

	if inA=1;
run;

data Combined;
	set combined;

	if price>5000 then
		price=.;
run;

data Combined;
	set Combined;

	if number_of_reviews=-999 then
		number_of_reviews=.;
run;

data Combined;
	set Combined;

	if room_type>.;

	if borough>.;
run;

proc means data=combined maxdec=2;
run;

*Find the following statistics for variable “price” for the listings that are in “Manhattan” (variable “borough”) and “room_type” is “Entire home/ apartment”.;
* Number of observations, Mean, Median, Standard Deviation, proc univariate;
*Method 1;

proc univariate data=Combined;
	var price;
	where borough=3 & room_type=1;
run;

*Method 2;

proc univariate data=Combined n mean median std maxdec=2;
	var price;
	where borough=3 and room_type=1;
run;

*Answer:
Number of observations: 12046
Mean: 242.26
Median: 190
Standard Deviation: 238.88;
*Using Chisq-Square Test and try to read the key findings;

proc freq data=combined;
	table borough * room_type / chisq;
run;

*/According the table generating by this Chi-Square, we can see a listing’s type (room_type) is no related to the borough it belongs to (borough).



*Create a new variable “reviews” to indicate whether the listing has received any reviews.;
variable reviews equal to zero if "number_of_reviews"=0, variable reviews equal 
	to one if "number_of_reviews">=1;

data Combined;
	set combined;

	if number_of_reviews=0 then
		reviews=0;

	if number_of_reviews>=1 then
		reviews=1;
run;

*Which of the following boroughs has the highest proportion of listings without any reviews?;

proc freq data=Combined;
	table borough;
run;

*If We are interested in understanding the relationship between logPrice and whether or not the listing had any reviews;

proc ttest data=Combined;
	var logPrice;
	class reviews;
run;

*/Based on the table of this Indenpend Sanple T Test, we should report the results from the Satterthwaite t-test and conclude that the average logPrice is significantly different between listings with and without any reviews/;
*Use room types 1 and 2 to find out whether logPrice depends on the listing’s borough and room type.;

proc glm data=Combined;
	class borough room_type;
	model logPrice=borough room_type borough*room_type/ss3;
	lsmeans borough / adj=Tukey;
	where room_type<3;
run;
*/As we can see from the results, the interaction between borough and room_type is less than 0.0001, which means the differences in logPrice among boroughs do not further depend on room_types/;
*/ When we conduct the post-hoc multiple comparison on borough, we can see no every pairwise comparison is significant cause borough 5 is not significantly different from borough 1 or borough 4./;

ODS PDF FILE = 'C:\Users\shen\Desktop\Graduate Study' STYLE= statistical;

ODS PDF CLOSE;