library(dplyr)
source('C:/R files/function files/DataConnections.R')

#Useage:
#MyUserHistory<- userHistory(userID = "fpm8", courses = c("CDC-U%","%OSSAM%"), completions = 1, allColumns = 0, adminCode = "HCVG", after = "1/1/2017", before = "10/1/2017")

userHistory <- function(userID=c(), courses=c(), completions=0, allColumns=1, adminCode="", after='', before=''){
  #always require a userid, may have course(s), 
  userRecords<-TrainingRecords(courseIDs=courses,userIDs=userID, adminCodeStr=adminCode, dateAfter = after, dateBefore = before)
  #return a subset of records
  if(allColumns==0){
    userRecords<-compactHistory(userRecords)
  }
  if(completions==1){
    #only return completions
    L<-userRecords$TrainingCompletionStatusCode == 200
    userComletedRecords<- userRecords[L,]
    userRecords <- userComletedRecords
  }

  userRecords
}

compactHistory <- function(records){
  columnsToReturn<- c("CDCUserID",
                      "HHSID", 
                      "LastName", 
                      "FirstName", 
                      "CDCAdminCode",
                      "EmploymentType",
                      "PersonCategoryText",
                      "JobSerNumber",
                      "OPMSupervisorCode", 
                      "HHSDeliveryTypeCode", 
                      "CourseCode", 
                      "CourseName",
                      "Score",
                      "CourseCompletionDate", 
                      "TrainingCompletionStatusCode")
  usefulRecords<-records[, columnsToReturn]
  usefulRecords
}