- Link: [[SAS- Begin with SAS (Coursera)]]
- # 1. Controlling DATA Step Processing
	- ## 1.1 Understanding DATA Step Processing
		- ### DATA Step Review
			- ![image.png](../assets/image_1665994873117_0.png){:height 269, :width 491}
		- ### DATA Step Processing
			- ![image.png](../assets/image_1665994981187_0.png){:height 123, :width 370}
		- ### DATA Step Processing: Compilation
			- Compilation:
				- STEP1: Check  for syntax errors
				- STEP2: Create the *program data vector* (PDV)
					- ![image.png](../assets/image_1665995072154_0.png){:height 117, :width 304}
					- PDV stands for one row of data at a time
					- SAS first goes through the entire `DATA` step to create a PDV, without calculating any values
				- STEP 3: Establish rules for processing data in the PDV
				- STEP 4: Create descriptor portion of output table.
			- e.g.
				- ![image.png](../assets/image_1665995227617_0.png){:height 154, :width 384}
				- ![image.png](../assets/image_1665995235492_0.png){:height 184, :width 390}
				- ![image.png](../assets/image_1665995293194_0.png){:height 206, :width 400}
				- ![image.png](../assets/image_1665995299532_0.png){:height 206, :width 413}
				- ![image.png](../assets/image_1665995406173_0.png){:height 222, :width 401}
					- `drop` will not remove a column, instead PDV marks a `drop` flag
				- ![image.png](../assets/image_1665995474595_0.png){:height 204, :width 408}
				- ![image.png](../assets/image_1665995489533_0.png){:height 203, :width 413}
					- Note that the *EndDate* is not included in the descriptor portion table.
		- ### DATA Step Processing: Execution
			- Execution
				- STEP1: Initialize PDV
				- STEP2: Read a row from the input table into the PDV
				- STEP3: Sequentially process statements and update values in the PDV
				- STEP4: At end of the step, write the contents of the PDV to the output table
				- STEP5: Return to the top of the `DATA` step
			- ![image.png](../assets/image_1665995754196_0.png){:height 239, :width 329}
			- ![image.png](../assets/image_1665995769087_0.png){:height 260, :width 342}
			- [[PDV_blog]]
		- ### Demo: DATA Step Processing in Action
			- ```sas
			  data storm_complete;
			  	set pg2.storm_summary_small;
			      length Ocean $ 8;
			      drop EndDate;
			      where Name is not missing;
			      Basin=upcase(Basin);
			      StormLength=EndDate-StartDate;
			      if substr(Basin,2,1)=="A" then Ocean='Atlantic';
			      else Ocean="Pacific";
			  run;
			  ```
			- PDV:
				- ![image.png](../assets/image_1665995909558_0.png){:height 206, :width 316}
		- ### Viewing Execution in the Log
			- `PUTLOG _ALL_`
	- ## 1.2 Directing DATA Step Output
		- ### Controlling DATA Step Processing
		- ### Implicit and Explicit Output
			- **Implicit**
				- ![image.png](../assets/image_1665997039292_0.png){:height 215, :width 436}
			- **Explicit**
				- use `OUTPUT;` to output data at specific time
		- ### Sending Output to Multiple
			- ![image.png](../assets/image_1665997163548_0.png){:height 126, :width 496}
			- you can create multi-table simultaneously by listing more table at `DATA` statement
			  id:: 634d1973-2002-4baf-87a8-b3eb39561dd4
			- `DATA table1 <table2 ...>`
		- ### Demo: Directing Row Output
			- ```sas
			  data storm_complete;
			  	set pg2.storm_summary;
			      length Ocean $ 8;
			      Basin=upcase(Basin);
			      StormLength=EndDate-StartDate;
			      MaxWindKM=MaxWindMPH*1.6;
			      if substr(Basin,2,1)="I" then do;
			      	Ocean="Indian";
			          output indian;
			  	   end;
			      else if substr(Basin,2,1)="A" then do;
			      	Ocean="Atlantic";
			          output atlantic;
			         end;
			  	else do;
			      	Ocean="Pacific";
			          output pacific;
			         end;
			  drop MaxWindMPH;
			  run;
			  ```
		- ### Controlling Column Output
			- `drop` or `keep` statement will perform on all tables in the `DATA` step
				- ![image.png](../assets/image_1665998824875_0.png)
			- Hence, if you want to perform differently to different tables, you can declare it individually.
				- ```sas
				  data sales_h (drop=Returns)
				  	 sales_l (drop=Inventory);
				  ```
				- ![image.png](../assets/image_1665998869145_0.png){:height 299, :width 468}
		- ### Demo: Directing Column Output
			- ```sas
			  data indian(drop=MaxWindMPH) atlantic(drop=MaxWindKM) pacific;
			  	set pg2.storm_summary(drop=MinPressure);
			      length Ocean $ 8;
			      Basin=upcase(Basin);
			      StormLength=EndDate-StartDate;
			      MaxWindKM=MaxWindMPH*1.6;
			      if substr(Basin,2,1)="I" then do;
			      	Ocean="Indian";
			          output indian;
			  	   end;
			      else if substr(Basin,2,1)="A" then do;
			      	Ocean="Atlantic";
			          output atlantic;
			         end;
			  	else do;
			      	Ocean="Pacific";
			          output pacific;
			         end;
			  run;
			  ```
			- Note (Also seen in next section ((634d0ff2-18f5-4375-b5d1-cf31e7ba2dbf))  ):
				- *If the `drop` statement are declared after `DATA table(DROP=col)`, the column and its data can still participate in calculating in `data` step*
				- *However, if `drop` is declared after `set`, the PDV will not include such column, and of course be excluded from all tables output*
					- ![image.png](../assets/image_1665999224584_0.png){:height 183, :width 416}
		- ### Columns in the PDV
		  id:: 634d0ff2-18f5-4375-b5d1-cf31e7ba2dbf
			- ![image.png](../assets/image_1665999309105_0.png){:height 229, :width 363}
			- ![image.png](../assets/image_1665999329690_0.png){:height 189, :width 344}
- # 2. Summarizing Data
	- ## 2.1 Creating an Accumulating Column
		- ### Demo: Creating an Accumulating Column
			- ```sas
			  data houston_rain;
			  	set pg2.weather_houston;
			      keep Date DailyRain YTDRain;
			      YTDRain=YTDRain+DailyRain;
			  run;
			  ```
		- ### Retaining Values in the PDV
			- **Demands:**
				- Initialization
				- Retaining
			- `RETAIN column <initial_value>`
				- ```sas
				  data houston2017;
				  	set pg2.weather_houston;
				      retain YTDRain 0;
				      YTDRain=YTDRain+DailyRain;
				  run;
				  ```
				- ![image.png](../assets/image_1666001846985_0.png){:height 156, :width 241}
		- ### Using the Sum Statement
			- ```sas
			  data zurich2017;
			  	set pg2.weather_zurich;
			      retain TotalRain 0;
			      TotalRain=sum(TotalRain,Rain_mm);
			  run;
			  ```
			- The code above can be shortened with `column+expression`
				- ![image.png](../assets/image_1666001962190_0.png){:height 115, :width 461}
				- ```sas
				  data zurich2017;
				  	set pg2.weather_zurich;
				      TotalRain+Rain_mm;
				  run;
				  ```
				- Such statement has done the following things:
					- creates column and sets initial value to zero
						- ![image.png](../assets/image_1666002083416_0.png){:height 98, :width 398}
					- retains the value of the accumulating column
						- ![image.png](../assets/image_1666002101249_0.png){:height 84, :width 403}
					- adds right column value to accumulating column for each row
						- ![image.png](../assets/image_1666002133681_0.png){:height 162, :width 393}
					- ignores missing values
						- ![image.png](../assets/image_1666002158693_0.png){:height 99, :width 399}
	- ## 2.2 Processing Data in Groups
		- ### Answering Questions about Groups
		- ### Processing Sorted Data in Groups
			- **Method**
				- First, create an output table that is sorted by a column that has groups you want to analyze.
					- ```sas
					  PROC SORT DATA = input_table
					  		< OUT = sorted_output_table>;
					          BY <DESCENDING> col_name(s);
					  RUN;
					  ```
				- Then, use the same statement in `DATA` step to tell SAS that you want to process the data in groups.
					- ```SAS
					  DATA output_table;
					  	SET sorted_output_table;
					      BY <DESCENDING> col_name(s);
					  RUN;
					  ```
			- ```sas
			  data storm2017;
			  	set storm_sort;
			      by Basin;
			  run;
			  ```
				- ![image.png](../assets/image_1666002554807_0.png){:height 120, :width 465}
		- ### Demo: Identifying the First and Last Row in Each Group
			- ```sas
			  proc sort data=pg2.storm_2017 out=storm2017_sort(keep=Basin Name);
			  	by Basin;
			  run;
			  data storm2017_max;
			  	set storm2017_sort;
			      by Basin;
			      First_Basin=first.basin;
			      Last_Basin=last.basin;
			  run;
			  ```
		- ### Subsetting Rows in the Execution Phase
			- ![image.png](../assets/image_1666003343886_0.png){:height 239, :width 436}
			- `IF expression`
				- ![image.png](../assets/image_1666003382582_0.png){:height 191, :width 333}
				- If false
					- ![image.png](../assets/image_1666003436528_0.png){:height 198, :width 435}
		- ### Demo: Creating an Accumulating Column within Groups
			- Demand:
				- ![image.png](../assets/image_1666003527690_0.png){:height 250, :width 228}
			- ```sas
			  data houston_monthly;
			  	set pg2.weather_houston;
			      keep Date Month DailyRain MTDRain;
			      by Month;
			      if First.Month=1 then MTDRain=0;
			      MTDRain+DailyRain;
			  run;
			  ```
		- ### Using Multiple BY Columns
			- ```sas
			  data sydney_summary;
			  	set pg2.weather_sydney;
			      by Year Qtr;
			  run;
			  ```
			- ![image.png](../assets/image_1666003803459_0.png){:height 140, :width 587}
			- ![image.png](../assets/image_1666003829098_0.png){:height 332, :width 598}
- # 3. Manipulating Data with Functions
	- ## 3.1 Understanding SAS Functions and CALL Routines
		- ### Review of Functions
			- `function (arg_1, arg_2, ...)`
			- ![image.png](../assets/image_1666004265892_0.png){:height 202, :width 415}
		- ### Specifying Columns Lists
			- `col -- col`
			- e.g.
				- ```sas
				  data quiz_summary;
				  	set pg2.class_quiz;
				      Name=upcase(Name);
				      AvgQuiz=mean(of Q:);
				      format Quiz1--AvgQuiz 3.1;
				      /*or*/ format _numeric_ 3.1;
				  run;
				  ```
				- ![image.png](../assets/image_1666004464356_0.png){:height 81, :width 450}
			- also, we can use other key words:
				- `_NUMERIC_`
				- `_CHARACTER_`
				- `_ALL_`
		- ### Using a CALL Routine to Modify Data
			- `CALL routine(arg_1/*col_names*/ <,... arg_n>);`
				- a `CALL routine` does not return a value; instead, it alters column values or performs other systems' functions.
				- e.g.
					- ```sas
					  data quiz_report;
					  	set pg2.class_quiz;
					      call sortn(of Quiz1-Quiz5);
					      QuizAvg=mean(of Quiz3-Quiz5);
					  run;
					  ```
	- ## 3.2 Using Numeric and Date Functions
		- ### Using Numeric Functions
			- `RAND('distribution', parameter1, parameter2...)`
			- `LARGEST(k, value1, <,value2...>)`
			- `ROUND(number<,rounding unit>)`
		- ### Demo: Using Numeric Functions
			- ```sas
			  data quiz_analysis;
			  	StudentID=rand("integer",1000,9999);
			  	set pg2.class_quiz;
			      drop Quiz-Quiz5;
			      Quiz1st=largest(1, of Quiz1-Quiz5);
			      Quiz2nd=largest(2, of Quiz1-Quiz5);
			      Quiz3rd=largest(3, of Quiz1-Quiz5);
			      Top3Avg=round(mean(Quiz1st,Quiz2nd,Quiz3rd),.1);
			  run;
			  ```
			- ![image.png](../assets/image_1666005325938_0.png){:height 265, :width 331}
		- ### Using Numeric Functions to Change Precision
			- These functions can be used to truncate decimal values.
				- | Function | What it Does |
				  | ---- | ---- | ---- |
				  | **CEIL** (*number*) | Returns the smallest integer that is greater than or equal to the argument. |
				  | **FLOOR** (*number*) | Returns the largest integer that is less than or equal to the argument. |
				  | **INT** (*number*) | Returns the integer value. |
		- ### SAS Date, Datetime, and Time Values
			- ![image.png](../assets/image_1666005459591_0.png){:height 206, :width 527}
		- ### Extracting Data from a Datetime Value
			- `DATEPART`
			- `TIMEPART`
		- ### Calculating Date Intervals
			- `INTCK('interval', start-date, end-date <,'method'>)`
				- `'interval'`: year, month, week, weekday, hour;
				- `'method'`
					- discrete (dafult)
						- ![image.png](../assets/image_1666005685167_0.png){:height 150, :width 287}
					- `'C'` :continuous
						- ![image.png](../assets/image_1666005746803_0.png){:height 97, :width 355}
		- ### Shifting Date Values
			- ![image.png](../assets/image_1666005788338_0.png)
			- `INTNX('interval', start, increment <,'alignment'>)`
				- `'interval'`: interval that you want to shift
				- `start`: SAS date column
				- `increment`: number of intervals to shift
				- `'alignment'`: position of SAS dates in the interval
		- ### Demo: Shifting Date Values Based on an Interval
			- ```sas
			  data storm_damage2;
			  	set pg2.storm_damage;
			      keep Event Date AssessmentDate;
			      AssessmentDate=intnx('month',Date,0);
			      format Date AssessmentDate date9.;
			  run;
			  ```
				- ![image.png](../assets/image_1666005998118_0.png){:height 275, :width 256}
			- ```sas
			  data storm_damage2;
			  	set pg2.storm_damage;
			      keep Event Date AssessmentDate;
			      AssessmentDate=intnx('month',Date,2);
			      format Date AssessmentDate date9.;
			  run;
			  ```
				- ![image.png](../assets/image_1666006025477_0.png){:height 244, :width 266}
			- ```sas
			  data storm_damage2;
			  	set pg2.storm_damage;
			      keep Event Date AssessmentDate;
			      AssessmentDate=intnx('month',Date,-1,'end');
			      format Date AssessmentDate date9.;
			  run;
			  ```
				- ![image.png](../assets/image_1666006054437_0.png){:height 204, :width 360}
			- ```sas
			  data storm_damage2;
			  	set pg2.storm_damage;
			      keep Event Date AssessmentDate Anniversary;
			      AssessmentDate=intnx('month',Date,-1,'middle');
			      Anniversary=intnx('year',Date,10,'same'); /*same date in 10 years*/
			      format Date AssessmentDate date9.;
			  run;
			  ```
				- ![image.png](../assets/image_1666006147782_0.png){:height 227, :width 327}
	- ## 3.3 Using Character Functions
		- ### Removing Characters from a string
			- These functions can be used to remove characters from a string.
			  | Function | What it Does |
			  | ---- | ---- | ---- |
			  | **COMPBL**(*string*) | Returns a character string with all multiple blanks in the source string converted to single blanks. |
			  | **COMPRESS**(*string* <, *characters*>) |  Returns a character string with specified characters removed from the source string. |
			  | **STRIP**(*string*) | Returns a character string with leading and trailing blanks removed. |
		- ### Extracting Words from a String
			- `SCAN(string, n<,'delimiters'>)`
				- `'delimiters'`
					- characters that separate words
					- by default: `blank ! $ % & () * + , - . / ; < ^ |`
			- e.g.
				- ```sas
				  City=scan(Location,1);
				  ```
		- ### Demo: Using Character Functions to Extract Words from a String
			- ```sas
			  data weather_japan_clean;
			  	set pg2.weather_japan;
			      Location=compb1(Location);
			      City=propcase(scan(Location,1, ','),' ');
			      Prefecture=scan(Location,2,',');
			      Country=scan(Location,-1,); /*-1 means to scan from right to left*/
			  run;
			  ```
				- ![image.png](../assets/image_1666006764179_0.png){:height 204, :width 465}
		- ### Searching for Character Strings
			- `FIND(string, substring <,'modifiers'>)`
				- `'modifiers'`:
					- `I`: case insensitive
					- `T`: trim leading and trailing blanks from string and substring
				- if substring is found: return start-position
				- if not found: return 0
				- e.g.
					- ```sas
					  AirportLoc=find(Station,'Airport')''
					  ```
					- ![image.png](../assets/image_1666006965897_0.png){:height 122, :width 342}
		- ### Identifying Character Positions
			- These functions return a numeric value that identifies the location of selected characters
			  | Function | What it Does |
			  | ---- | ---- | ---- |
			  | **LENGTH**(*string*) | Returns the length of a non-blank character string, excluding trailing blanks; returns 1 for a completely blank string. |
			  | **ANYDIGIT**(*string*) | Returns the first position at which a digit is found in the string. |
			  | **ANYALPHA**(*string*) | Returns the first position at which an alpha character is found in the string. |
			  | **ANYPUNCT**(*string*) | Returns the first position at which punctuation character is found in the string. |
		- ### Replacing Character Strings
			- `TRANWRD(source, target, replacement)`
				- `source`: character column
				- `target`: string to find
				- `replacement`: replacement string
			- e.g.
				- ```sas
				  Summary2=tranwrd(Summary, 'hurricane', 'storm');
				  ```
				- ![image.png](../assets/image_1666007133168_0.png){:height 83, :width 451}
		- ### Building Character Strings
			- These functions can be used to combine strings into a single character value. The arguments can be either character or standard numeric values.
			  | Function | What it Does |
			  | ---- | ---- | ---- |
			  | **CAT**(*string1, ... stringn*) | Concatenates strings together, does not remove leading or trailing blanks. |
			  | **CATS**(*string1, ... stringn*) | Concatenates strings together, removes leading or trailing blanks from each string. |
			  | **CATX**('*delimiter*', *string1, ... stringn*) | Concatenates strings together, removes leading or trailing blanks from each string, and inserts the delimiter between each string. |
	- ## 3.4 Using Special Functions to Convert Column Type
		- ### Handling Column Type
		- ### Converting Column Type
			- **automatic conversion character to numeric**
				- success:
					- ![image.png](../assets/image_1666007290359_0.png){:height 213, :width 195}
				- failure:
					- ![image.png](../assets/image_1666007298809_0.png){:height 210, :width 214}
			- **automatic conversion numeric to character**
			- `INPUT(source, informat)`
				- char to num;
				- `informat`: indicate how the char string should be read
			- `PUT(source, format)`
				- num to char
				- `format`: how to write the char string
		- ### Converting Character Values to Numeric Values
			- `Date2=input(Date,date9.)`
				- ![image.png](../assets/image_1666007766743_0.png){:height 207, :width 578}
				- ![image.png](../assets/image_1666007789273_0.png){:height 271, :width 449}
			- **Pay attention to the decimal**
				- In conversion, we do not need to specify the decimal in `informat` if the decimal point is in the correct place
				- On the other hand, however, if we wrongly added a decimal point in `informat`, SAS will still automatically run the program without warning. *Take NewVolume2 as an example:*
					- ```sas
					  data work.stocks2;
					  	set pg2.stocks2;
					      NewVolume1=input(Volume, comma12.);
					      NewVolume2=input(Volume, comma12.2);
					      keep volume newvolume:;
					  run;
					  ```
					- ![image.png](../assets/image_1666008051780_0.png){:height 256, :width 434}
		- ### Using a Generic Informat to Read Dates
			- `ANYDTDTEw.`
				- ![image.png](../assets/image_1666008109027_0.png){:height 259, :width 422}
				- `DATESTYLE`
					- `DATESTYLE=LOCALE`
						- if `LOCALE=ENGLISH`, then `DATESTYLE=MDY`
					- other options:
						- `DATESTYLE=MDY`
						- `DATESTYLE=DMY`
		- ### Converting the Type of an Existing Column
			- The type of an existing column cannot be changed directly. Therefore, we have to first create a new column with the proper type we need, and then assign the value to the origin one.
			- ![image.png](../assets/image_1666008444050_0.png){:height 166, :width 387}
			- **Procedure**
				- STEP1: use `table(RENAME=(current_col_name=new_col_name))`
					- e.g.
						- ```sas
						  data work.stock;
						  	set pg2.stocks2(rename=(Volume=CharVolume));
						  ```
						- ![image.png](../assets/image_1666008649465_0.png){:height 93, :width 511}
				- STEP2: `input`
					- e.g.
						- ```sas
						  data work.stock;
						  	set pg2.stocks2(rename=(Volume=CharVolume));
						      Date2=input(Date,date9.);
						      Volume=input(CharVolume,comma12.);
						  ```
					- STEP3: `drop`
						- e.g.
							- ```sas
							  data work.stock;
							  	set pg2.stocks2(rename=(Volume=CharVolume));
							      Date2=input(Date,date9.);
							      Volume=input(CharVolume,comma12.);
							  	drop CharVolume;
							  run;
							  ```
		- ### Converting Numeric Values to Character Values
			- `PUT(source, format)`
			- ![image.png](../assets/image_1666008990371_0.png)
				- ```sas
				  Day=put(Date,downame3.);
				  ```
			- ![image.png](../assets/image_1666009023528_0.png){:height 267, :width 466}
		- ### Demo: Using the INPUT Function to Convert Column Types
			- raw input data:
				- ![image.png](../assets/image_1666009097534_0.png)
			- ```sas
			  data atl_precip;
			  	set pg2.weather_atlanta;
			      where AirportCode='ATL';
			      drop AirportCode City Temp:ZipCode Precip;
			      TotalPrecip+Precip;
			      if Precip ne 'T' then PrecipNum=input(Precip,6.);
			      else PrecipNum=0;
			      TotalPrecip+PrecipNum;
			  run;
			  
			  data atl_precip;
			  	set pg2.weather_atlanta;
			      CityStateZip=catx('',City,"GA",ZipCode);
			  run;
			  ```
			-
- # 4. Creating and Using Custom Formats
	- ## 4.1 Creating and Using Custom Formats
		- ### Formatting Data Values
			- ```sas
			  proc print data=pg2.class_birthdate noobs;
			  	format Height Weight 3.0 Birthdate data9.;
			  run;
			  ```
		- ### Creating and Applying a Custom Format
			- **Custom format**
				- ```sas
				  PROC FORMAT;
				  	VALUE format_name value_or_range_1='formatted_value'
				      				  value_or_range_2='formatted_value'
				                        ...;
				  RUN;
				  ```
				- `format_name`
					- up to 32 chars
					- char format: $+letter/_
					- num format: letter/_
					- cannot end in number
				- `value_or_range_1`
					- char values needs to be quoted by ' '
			- **create format**
				- ```sas
				  proc format;
				  	value $regfmt 'C'='Complete'
				      			  'I'='Incomplete';
				  run;
				  ```
			- **apply format**
				- ```sas
				  proc print data=pg2.class_birthdate;
				  	format Registration $regfmt.;
				  run;
				  ```
		- ### Using Ranges
			- ```sas
			  value hrange 50-<58='Below Average' /*[50,58)*/
			  			 58-60='Average'	/*[58,60]*/
			               60<-70='Above Average'; /*(60,70]*/
			  ```
			- ```sas
			  value hrange low-<58='Below Average' /*low for the lowest value*/
			  			 58-60='Average'	
			               60<-high='Above Average'; /*high for the highest*/
			  ```
			- ```sas
			  value $regmt 'C'='Complete'
			  			 'I'='Incomplete'
			               other='Miscoded'; /*all values that do not match*/
			  ```
		- ### Demo: Creating and Using Custom Formats
	- ## 4.2 Creating Custom Formats from Tables
		- ### Reading a Table of Values for a Format
			- ![image.png](../assets/image_1666063916865_0.png){:height 183, :width 220}
				- ```sas
				  proc format;
				  	value $sbfmt
				      	  'AS'='Arabian Sea'
				            'BB'='Bay of Bengal'
				            /*... ...*/
				            'MM'='Missing';
				  run;
				  ```
			- **Requirement:**
				- ![image.png](../assets/image_1666064021325_0.png){:height 160, :width 342}
				- ![image.png](../assets/image_1666064043506_0.png){:height 139, :width 257}
			- **creating an converting table**
				- ![image.png](../assets/image_1666064075618_0.png){:height 129, :width 414}
				- ```sas
				  data work.sbdata;
				  	retain FmtName '$sbfmt';
				      set pg2.storm_subbasincodes(rename=(Sub_Basin=Start
				      									SubBasin_Name=Label));
				  	keep Start Label FmtName;
				  run;
				  ```
			- **loading the converting table**
				- ```sas
				  PROC FORMAT CNTLIN=work.sbdata;
				  RUN;
				  ```
			- **applying the converting table**
				- ```sas
				  proc freq data=pg2.storm_detail;
				  	tables Sub_basin*Wind/nocol norow nopercent;
				      format Sub_basin $sbfmt. Wind catfmt.;
				  run;
				  ```
		- ### Storing Custom Formats
			- ![image.png](../assets/image_1666064772796_0.png){:height 101, :width 262}
			- ![image.png](../assets/image_1666064797454_0.png){:height 85, :width 242}
			- ![image.png](../assets/image_1666064821611_0.png){:height 74, :width 186}
			- `options fmtsearch=`
				- to locate the format address
				- e.g.`options fmtsearch=(pg2.myfmts sashelp);`
					- ![image.png](../assets/image_1666064886907_0.png){:height 66, :width 312}
- # 5. Combining Tables
	- ## 5.1 Concatenating Tables
		- ### Concatenating Tables with Matching Columns
			- *if columns have same names, lengths & types:*
				- ```sas
				  DATA output_table;
				  	SET input_table1 input_table2;
				      ... addtional statements ...;
				  RUN;
				  ```
			- e.g.
				- ```sas
				  data class_current;
				  	set sashelp.class pg2.class_new;
				  run;
				  ```
				- ![image.png](../assets/image_1666065283402_0.png){:height 144, :width 336}
			- demo:
				- ![image.png](../assets/image_1666065442095_0.png){:height 114, :width 365}
				- ![image.png](../assets/image_1666065460747_0.png){:height 204, :width 361}
		- ### Handling Column Attributes
			- When adding multiple tables with `SET` statement, columns from the first table will be added to the PDV with their corresponding attributes.
			- When SAS reads the second table in `SET`, the attributes of any columns that are already in the PDV cannot be changed.
				- e.g.
					- ```sas
					  data class_current;
					  	set sashelp.class;
					      	pg2.class_new2(rename=(Student=Name));
					  run;
					  ```
						- ![image.png](../assets/image_1666065506266_0.png){:height 104, :width 265}
			- To solve this problem, we can clarify the attributes before `SET`
				- e.g.
					- ```sas
					  data class_current;
					  	length Name $9;
					      set sashelp.class
					      	pg2.class_new2(rename=(Student=Name));
					  run;
					  ```
					- ![image.png](../assets/image_1666065821642_0.png){:height 72, :width 261}
	- ## 5.2 Merging Tables
		- ### What is a Merge?
			- `PROC SQL`
			- `DATA MERGE`
				- matching common columns
				- ![image.png](../assets/image_1666075902683_0.png){:height 229, :width 414}
		- ### Processing a One-to-One Merge
			- ```sas
			  DATA output_table;
			  	MERGE input_table1 input_table2 ...;
			      BY BY-column(s);
			  RUN;
			  ```
				- Note: These data must in sorted order, so typically use `PROC SORT` statement before `MERGE`
			- example:
				- ![image.png](../assets/image_1666075984234_0.png){:height 120, :width 560}
				- ```sas
				  data class2;
				  	merge sashelp.class pg2.class_teachers;
				      by name;
				  run;
				  ```
				- Process:
					- *First, create a PDV from first table1, then table2, etc.*
						- ![image.png](../assets/image_1666076157473_0.png){:height 104, :width 581}
					- *Then, if both rows match, the data is written.*
					- ![image.png](../assets/image_1666076196100_0.png){:height 94, :width 555}
		- ### Processing a One-To-Many Merge
			- example
				- ```sas
				  data class2;
				  	merge teachers_sort test2_sort;
				      by name;
				  run;
				  ```
				- ![image.png](../assets/image_1666076355249_0.png)
				- **Procedure**
					- ![image.png](../assets/image_1666076393646_0.png){:height 182, :width 496}
					- ![image.png](../assets/image_1666076402603_0.png){:height 192, :width 451}
					- ![image.png](../assets/image_1666076489394_0.png){:height 168, :width 467}
					- ![image.png](../assets/image_1666076604990_0.png){:height 177, :width 476}
					- ![image.png](../assets/image_1666076634145_0.png){:height 183, :width 484}
			- Demo:
				- ![image.png](../assets/image_1666076759815_0.png){:height 191, :width 466}
	- ## 5.3 Identifying Matching and Non-matching Rows
		- ### Merging Tables with Non-matching Rows
			- ![image.png](../assets/image_1666076819851_0.png){:height 322, :width 493}
		- ### Identifying Matches and Non-matches
			- ```sas
			  DATA output_table;
			  	MERGE input_table1(IN=variable);
			      	  input_table2(IN=variable);
			  	BY by_column(s);
			  RUN;
			  ```
			- example
				- ```sas
				  data class2;
				  	merge pg2.class_update(in=inUpdate)
				      	  pg2.class_teachers(in=inTeachers);
				  	by name;
				  run;
				  ```
				- ![image.png](../assets/image_1666077096606_0.png){:height 121, :width 481}
				- ![image.png](../assets/image_1666077113539_0.png){:height 113, :width 477}
				- ```sas
				  data class2;
				      merge pg2.class_update(in=inUpdate) 
				            pg2.class_teachers(in=inTeachers);
				      by name;
				      if inUpdate=1 and inTeachers=1;
				  run;
				  ```
			- Demo:
				- ![image.png](../assets/image_1666077236284_0.png)
		- ### Merging Tables with Matching Column Names
			- ![image.png](../assets/image_1666077274223_0.png){:height 260, :width 453}
			- First table in PDV is overwritten
				- ![image.png](../assets/image_1666077301233_0.png){:height 142, :width 355}
			- Solution:
				- ```sas
				  data weather_sanfran;
				  	merge pg2.weather_sanfran2016(rename=(AvgTemp=AvgTemp2016))
				      	  pg2.weather_sanfran2017(rename=(AvgTemp=AvgTemp2017));
				      by month;
				  run;
				  ```
				- ![image.png](../assets/image_1666077419797_0.png){:height 206, :width 262}
		- ### Merging Tables without a Common Column
			- `DATA step merge`
			- example
				- ![image.png](../assets/image_1666077469666_0.png){:height 109, :width 539}
				- *First, merge by Name*
					- ```sas
					  data update_teachers;
					  	merge pg2.class_update
					      	  pg2.class_teachers;
					  	by Name;
					  run;
					  ```
				- *Then, sort by Teacher and merge*
					- ```sas
					  proc sort data=update_teachers;
					  	by Teacher;
					  run;
					  data class_combine;
					  	merge update_teachers;
					      	  pg2.class_rooms;
					  	by Teacher;
					  run;
					  ```
			- However, this kind of task can be more easily done with `PROC SQL`
				- ```sas
				  proc sql;
				  create table class_combine as
				  select u.*, t.Grade, t.Teacher, r.Room
				  	from pg2.class_update as u
				      inner join pg2.class_teachers as t
				      	on u.Name=t.Name
				  	inner join pg2.class_rooms as r
				      	on t.Teacher=r.Teacher;
				  quit;
				  ```
		- ### DATA Step Merge and PROC SQL Join
			- **DATA step merge**
				- requires sorted input data
				- efficient, sequential processing
				- can create multiple output tables for matches and non-matches in one step
				- provides additional complex data processing syntax
			- **PROC SQL join**
				- does not require sorted data
				- matching columns do not need the same name
				- easy to define complex matching criteria between multiple tables in a single query
				- can be used to create a Cartesian product for many to many joins
- # 6. Processing Repetitive Code
	- ## 6.1 Using Iterative DO Loops
		- ### Iterative Do Loops
			- ```sas
			  DO index_column = start TO stop <BY increment>;
			  	... repetitive code ...
			  END;
			  ```
				- `index_column`:
					- value controls DO loop execution
					- is included in the output unless is dropped
				- `BY increment`
					- default = 1
			- ### Demo: Executing an Iterative Do Loop
				- ![image.png](../assets/image_1666082335182_0.png){:height 134, :width 410}
				- ![image.png](../assets/image_1666082350005_0.png){:height 234, :width 260}
		- ### Output Inside and Outside the DO Loop
			- Inside
				- ![image.png](../assets/image_1666082438782_0.png){:height 176, :width 346}
			- Outside
				- ![image.png](../assets/image_1666082491872_0.png){:height 178, :width 348}
			- ![image.png](../assets/image_1666082530458_0.png){:height 188, :width 400}
	- ## 6.2 Using Conditional DO Loops
		- ### Conditional DO Loops
			- `DO UNTIL( ); ... END;`
			- `DO WHILE( ); ... END;`
		- ### Checking the Condition
			- ![image.png](../assets/image_1666089698985_0.png){:height 200, :width 488}
			- ![image.png](../assets/image_1666089737456_0.png){:height 160, :width 502}
		- ### Combining Iterative and Conditional DO Loops
			- `DO ... = start TO stop <BY increment> UNTIL / WHILE `
- # 7. Restructuring Tables
	- ## 7.1 Restructuring Data with the DATA Step
		- ### Understanding Table Structure
			- ![image.png](../assets/image_1666090040369_0.png){:height 185, :width 469}
		- ### Restructuring Data
			- **wide to narrow:**
				- ```sas
				  data class_test_narrow / ldebug;
				  	set pg2.class_test_wide;
				      keep Name Subject Score;
				      length Subject $7;
				      Subject='Math';
				      Score=Math;
				      output;
				      Subject = "Reading";
				      Score=Reading;
				      output;
				  run;
				  ```
			- **narrow to wide:**
				- ```sas
				  if TestSubject="Math" then Math=TestScore;
				  else if TestSubject="Reading" then Reading=TestScore;
				  ```
	- ## 7.2 Restructuring Data with the TRANSPOSE Procedure
		- ### The Transpose Procedure
			- `PROC TRANSPOSE DATA`
				- ```SAS
				  PROC TRANSPOSE DATA=input_table <OUT=output_table>;
				  	<ID col_name;>
				      <VAR col_name(s);>
				  RUN;
				  ```
		- ### Transposing Values within Groups
			- ![image.png](../assets/image_1666090840942_0.png){:height 227, :width 499}
			- Demo:
				- ```sas
				  proc transpose data=pg2.storm_top4_narrow out=wind_rotate prefix=Wind name=WindSource;
				  	var WindMPH;
				  	id WindRank;
				  	by Season Basin Name;
				  run;
				  ```
				- ![image.png](../assets/image_1666091364600_0.png){:height 238, :width 452}
		- ### Creating a Narrow Table with PROC TRANSPOSE
			- ![image.png](../assets/image_1666091431358_0.png){:height 195, :width 535}
		- ### Changing Column Names
			- ```sas
			  PROC TRANSPOSE DATA=input_table <OUT=output_table>
			  				<NAME=column><PREFIX=column>;
			  ```
-