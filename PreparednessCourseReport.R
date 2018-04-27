source('TrainingRecordFunctions.R')
library(xlsx)

courseInfoFile = "data\\PreparednessCourses-2017-08-31-Renamed.xlsx"
DateFrom <- "2004-1-1"
DateTo <- "2017-9-1"

#Read the spreadsheet of course info into a data frame
SPOCourseInfo <-read.xlsx(courseInfoFile, 1)

#Pull the course ids from the course info
SPOCourses <- SPOCourseInfo$Course.ID

#Pull SPO course completions from the user history 
#using the userHistory() function in TrainingRecordFunctions.R
PreparednessCompletions <- userHistory(userID=c(),courses=SPOCourses,completions=1,allColumns=0)

#Add a column that concatenates the course name and id
PreparednessCompletions$Course <- paste(PreparednessCompletions$CourseName, " (", PreparednessCompletions$CourseCode, ")")

#Add a column that matches the course category from course info with the course id from the completions
PreparednessCompletions$Group<-SPOCourseInfo[match(PreparednessCompletions$CourseCode,SPOCourseInfo$Course.ID),3]

#Add a column that matches the course category from course info with the course id from the completions
PreparednessCompletions$Competency<-SPOCourseInfo[match(PreparednessCompletions$CourseCode,SPOCourseInfo$Course.ID),4]

#Create a True/False vector based on the completion date range
L <- PreparednessCompletions$CourseCompletionDate > DateFrom & PreparednessCompletions$CourseCompletionDate < DateTo

#Filter the completions by the date range
PreparednessCompletions <- PreparednessCompletions[L,]

#An existing file with the pivot table already made
completionsFile = "data\\PreparednessCourseCompletions.xlsx"

#Load completions file into a workbook object so we can manipulate the data sheet,
#but leave the summary sheet intact (with the pivot table).
wb <- write.xlsx2(PreparednessCompletions, completionsFile, row.names=FALSE)
#wb <- write.csv(PreparednessCompletions, file = completionsFile)

