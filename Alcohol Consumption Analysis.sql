/* we created a new database named 'brfss'*/
CREATE DATABASE brfss;
USE brfss;

-- Create the Demographic table
CREATE TABLE Demographic (
  zip_code VARCHAR(10) PRIMARY KEY,
  city VARCHAR(50),
  county VARCHAR(50)
);

-- Create the Demographic_OK table
CREATE TABLE Demographic_OK (
  zip_code VARCHAR(10) PRIMARY KEY,
  city VARCHAR(50),
  county VARCHAR(50)
);

-- Create the Heavy_Drinking_Survey fact table
CREATE TABLE Heavy_Drinking_Survey (
  brfss_id int AUTO_INCREMENT,
  question VARCHAR(200),
  response VARCHAR(10),
  break_out VARCHAR(10),
  break_out_category VARCHAR(20),
  sample_size INT,
  data_value FLOAT,
  zip_code VARCHAR(10),
  PRIMARY KEY (brfss_id)
);

/* Merge two dimension tables demographics_OK and Demographics*/
CREATE TABLE `ALL_demographics` (
SELECT *
FROM Demographic_OK
UNION
SELECT *
FROM Demographic
);

/* Adding primary key to 'merged_demographics' table*/
ALTER TABLE All_demographics
ADD PRIMARY KEY (zip_code);

/*Adding primary key and foreign key relations*/
ALTER TABLE Heavy_Drinking_Survey
ADD FOREIGN KEY (Zip_Code) REFERENCES All_demographics(zip_Code);

/*Exploring the Data in Heavy_Dring_Survey*/
SELECT *
FROM Heavy_Drinking_Survey
LIMIT 10;

/*Understanding the total Sample_Size and Data_Value for each category in the Break_Out_Category column*/
SELECT Break_Out_Category, SUM(Sample_Size), SUM(Data_value)
FROM Heavy_Drinking_Survey
GROUP BY Break_Out_Category;

/*Explore the responses (“Y”) that are relevant to adolescent alcohol consumption*/
SELECT *
FROM Heavy_Drinking_Survey
WHERE 
Response = 'Yes'
AND Break_Out_Category = 'Age Group'
AND Break_Out = '18-24'
ORDER BY Data_value DESC;

/* Percentage of adolescent alcohol consumption sorted in descending order*/
SELECT Break_Out, AVG(CEIL((Data_value/Sample_Size)*100)) as Percent_AAC
FROM Heavy_Drinking_Survey
WHERE 
Response = "Yes" AND
Break_Out_Category = "Age Group"
GROUP BY Break_Out
ORDER BY Percent_AAC DESC;

/* The highest and lowest number of adolescent abusers,with accordance to counties of oklahoma state*/
SELECT 
    ad.County,
    HDS.Response,
    HDS.Break_Out,
    HDS.Break_Out_Category,
    HDS.Sample_Size,
    MAX(HDS.Data_value) as 'MAX Data Value',
    MIN(HDS.Data_value) as 'MIN Data Value'
FROM Heavy_Drinking_Survey AS HDS
INNER JOIN All_demographics AS ad ON HDS.zip_Code = ad.zip_Code
WHERE HDS.Break_Out = '18-24'
GROUP BY ad.County , HDS.Response , HDS.Break_Out , HDS.Break_Out_Category , HDS.Sample_Size;

/* The highest and lowest number of adolescent abusers,with accordance to cities of oklahoma state*/
SELECT 
    ad.City,
    HDS.Response,
    HDS.Break_Out,
    HDS.Break_Out_Category,
    HDS.Sample_Size,
    MAX(HDS.Data_value) as 'MAX Data Value',
    MIN(HDS.Data_value) as 'MIN Data Value'
FROM Heavy_Drinking_Survey AS HDS
INNER JOIN All_demographics AS ad ON HDS.zip_Code = ad.zip_Code
WHERE HDS.Break_Out = '18-24'
GROUP BY ad.City , HDS.Response , HDS.Break_Out , HDS.Break_Out_Category , HDS.Sample_Size;






