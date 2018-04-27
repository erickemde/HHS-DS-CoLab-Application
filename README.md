# HHS-DS-CoLab-Application
Add some text here.
## 1. First and Last Name
> Erick Emde
## 2. Work Email Address
FPM8@CDC.GOV
## 3. What OpDiv are you in? 
> CDC
# 4. What does your office do? (150 characters max) 
> I am in CDC's HR IT department, Systems Administration and Data Analytics Team. We pull meaning from CDC's HR data. I deal mostly with training data.
## 5. How often do you personally work with large* datasets (in any capacity)?
*i.e., analysis/processing is necessary to make use of the data 
>  Weekly (at least)
## 6. What kind of data and datasets do you work with?
### Most Often
> * Source: Training Data
> * Types : Numeric, Dates, Categorical, Text
> * Formats : SQL, Excel
### 2nd Most Often
> * Source: People (HR) Data
> * Types : Numeric, Dates, Categorical, Text
> * Formats : SQL, Excel, Dashboards
### 3rd Most Often
> * Source: Training Evaluation Data
> * Types : Numeric, Text
> * Formats : SQL, .CSV
### Not yet, but I'd like to:
> * Source: Experience API Data (internet of things for learning)
> * Types : Text
> * Formats : JSON
## 7. What specific data-related challenge would you like to solve with data science knowledge and tools? Why?
>I'm interested in creating a training data infrastructure for CDC. This would have multiple benefits for CDC, including improving decision making, increasing automation, allowing data mining and data visualizations. We've already got a lot of the pieces (2 million+ training records, HR records, etc.) and we're creating more (electronic IDP, online competency assessment tool). We need help figuring out what else we need and how best to put this all together to be a really useful tool. In the first phases, I'm imagining that it will be an improved way to do training and development reporting, but it has the potential to grow into a real employee development and succession planning tool. 
## 8. Is solving this or any other data-related challenge a priority for your leadership, including your immediate supervisor? 
> We are already working on some of the tools needed. And my boss's boss is directly responsible for the CDC's HR automation  efforts, which are one of CDC HR Organization's strategic priorities.
## 9. What's an example of work or project (can be work, school, or other) where you have used data tools (e.g., Excel/Google Sheets, SPSS, SAS), quantitative methods (e.g., statistics) and/or programming experience (e.g., SQL, R, Python) to achieve your goal?
> I used a number of data tools in a recent report I created for the CDC IT Strategic Plan. I needed to find the key performance indicators (KPIs) involving IT related training for 2210 series employees over the past 7 years, by year and half-year. We needed to know total and average hours of all IT training, online training, and the number and hours of training added per time period.To do this, I had to:
> 1. Download the most recent list of online courses from the Learning Management System (LMS)
> 2. Import this data into a local, Access db
> 3. Join this local data with training records in a SQL Server db to pull all training taken by 2210s
> 4. Run a query to clean the data so that it only included IT related training
> 5. Export the data and work with SMEs to confirm no non-IT courses were included
> 6. Bring the data into an Excel spreadsheet, then create a summary tab that displays the KPIs
## 10. Please copy/paste a sample snippet of working code that you have created or applied (optional -- 2000 characters max). 
Here is some R code I created to run a report on some preparedness training: [PreparednessCourseReport.R](https://github.com/erickemde/HHS-DS-CoLab-Application/PreparednessCourseReport.R)
