library(RODBC)

# Returns training records filtered by courseid, userid, admin code and/or date
# Usage: userRecords<-TrainingRecords(courseIDs=courses,userIDs=userID, adminCodeStr=adminCode, dateAfter = after, dateBefore = before)

TrainingRecords <- function(courseIDs=c(), userIDs=c(), adminCodeStr='', dateAfter = '', dateBefore=''){
  #stop the function if no aurguments are entered.
  if(missing(courseIDs) && missing(userIDs) && missing(adminCodeStr)){
    stop("You must enter at least one course id or user id")
  }
  
  #initialize the filter strings
  courseIDFilterStr<-''
  userIDFilterStr<-''
  FilterStr<-''
    
  #if there are course id(s), create the course id filter string  
  if(length(courseIDs)>0)
    {
      courseIDFilterStr <- IDFilter('CourseCode', courseIDs)
      FilterStr <- paste("WHERE", courseIDFilterStr)
    }

  #if there are user id(s), create the user id filter string  
  if(length(userIDs)>0)
    {
      userIDFilterStr <- IDFilter('UserID', userIDs)
      FilterStr <- paste("WHERE", userIDFilterStr)
    }
  
  #if there are both course AND user id(s), concatenate them   
  if(courseIDFilterStr!='' && userIDFilterStr!=''){
      FilterStr <- paste("WHERE ", courseIDFilterStr, " AND ", userIDFilterStr)
    }

    #if there is an admin code, add it to the filter  
  if(adminCodeStr != ''){
    if(courseIDFilterStr=='' && userIDFilterStr==''){
      FilterStr <- paste("WHERE AdminCode LIKE '", adminCodeStr, "%'", sep = "")
    }else{
      FilterStr <- paste(FilterStr, " AND AdminCode LIKE '", adminCodeStr, "%'", sep = "")
    }
  }

  #if there is a dateAfter, add it to the filter  
  if(dateAfter != ''){
    FilterStr <- paste(FilterStr, " AND CourseCompletionDate >= '", dateAfter, "'", sep = "")
  }

  #if there is a dateBefore, add it to the filter  
  if(dateBefore != ''){
    FilterStr <- paste(FilterStr, " AND CourseCompletionDate < '", dateBefore, "'", sep = "")
  }
  
  #create the query string
  queryStrBase <- "Select T.*, P.*"
  queryStrBase <- paste(queryStrBase, "FROM [SQL_SVR_DB].[dbo].[ExtTraining_VW] AS T INNER JOIN [MISO_PERSON].[dbo].[ExtPersonActive_VW] AS P")
  queryStrBase <- paste(queryStrBase, "ON T.UserID = P.UserID")
  query <- paste(queryStrBase, FilterStr) 
  print(query)
  
  #run the query
  resTrainingRecords <- runLMSQuery(query)
}

#Returns all trainining records for user(s)
trainingRecordsEverything <- function(userIDs=c()){
  #stop the function if no aurguments are entered.
  if(missing(userIDs)){
    stop("You must enter at least one user id")
  } 
  #initialize the filter strings
  userIDFilterStr<-''
  FilterStr<-''
  #if there are user id(s), create the user id filter string  
  if(length(userIDs)>0)
  {
    userIDFilterStr <- IDFilter('[SQL_SVR_DB].[dbo].[DMGRPH].[user_id]', userIDs)
    FilterStr <- paste("WHERE", userIDFilterStr)
  }
  #create the query string
  queryStem <- "SELECT [SQL_SVR_DB].[dbo].[DMGRPH].* ,[SQL_SVR_DB].[dbo].[TRNG_RCD].*"
  queryStem <- paste(queryStem, "FROM [SQL_SVR_DB].[dbo].[TRNG_RCD] INNER JOIN [SQL_SVR_DB].[dbo].[DMGRPH]")
  queryStem <- paste(queryStem, "ON [SQL_SVR_DB].[dbo].[TRNG_RCD].[people_dmgrph_id] = [SQL_SVR_DB].[dbo].[DMGRPH].[people_dmgrph_id]")
  query <- paste(queryStem , FilterStr) 
  
  print(query)
  
  #run the query
  resTrainingRecords <- runLMSQuery(query)}


#Generic function that pairs the field name with the id and concatenates it if there is more than one ID
IDFilter <-function(IDField, IDvalues){
  IDFilter<-""
  for(ID in 1:length(IDvalues)){
    comparison <- " = '"
    if(grepl("%", IDvalues[ID])==TRUE){
      comparison <- " LIKE '"
    }
    if(ID==1)
    {
      IDFilter<- paste(IDField, comparison, IDvalues[ID], "'", sep="")
    }else{
      IDFilter<- paste(IDFilter, " OR ", IDField, comparison , IDvalues[ID], "'", sep="")
    }
  }
  IDFilter <- paste("(", IDFilter, ")")
  IDFilter
}

# Returns all members of an audience type
# Useage: myAudType <- audienceTypeMembers(c('CDC-2017%','CDC-2016%'))

audienceTypeMembers <- function(audienceType=c()){
  #stop the function if no aurguments are entered.
  if(missing(audienceType)){
    stop("You must enter an audience type")
  }
  #build the beginning of the query
  queryStem<-"SELECT A.[audnc_type_nm] ,A.[user_id], P.[AdminCode], P.[OPMSupervisorCode] FROM [SQL_SVR_DB].[dbo].[USER_AUDNC] A LEFT JOIN [MISO_PERSON].[dbo].[ExtPersonActive_VW] P ON A.[user_id] = P.[UserID] Where A.[user_audnc_actv_ind]='Y' AND "
  filterParams <- IDFilter('A.[audnc_type_nm]', audienceType) 
  #paste in the audience type
  query <- paste(queryStem, filterParams, "ORDER BY A.[user_id]", sep = "") 
  #run the query
  resAudienceTypeMembers <- runLMSQuery(query)
}

#Useage:
# Return offering: ncird <- MTMSent("offering", '00131948')
# Return courses: SBM004 <- MTMSent("course", 'cdc-u-sbm-0004')

MTMSent <- function(CourseOrOffering="", IDs=c()){

  #build the beginning of the query
  queryStem<-"SELECT * FROM [SQL_SVR_DB].[dbo].[MTM_EXTRACT_ILT]"
  filterParams = ""

  if(CourseOrOffering !=""){
    if(CourseOrOffering =="course"){
      filterField = "[Course ID]"
    }
    if(CourseOrOffering =="offering"){
      filterField = "[Unique Class ID]"
    }
    filterParams <- IDFilter(filterField, IDs) 
    filterParams <- paste("WHERE", filterParams)
  }
  #paste in the audience type
  query <- paste(queryStem, filterParams) 
  #run the query
  resAudienceTypeMembers <- runLMSQuery(query)
}

#Useage:
#currentAudienceTypes <- audienceTypes()
#filterForFTE <- filter(currentAudienceTypes, grepl("fte", audnc_type_nm, ignore.case = TRUE))

audienceTypes <- function(){
  query <- "SELECT * FROM [SQL_SVR_DB].[dbo].[AUDNC_TYPE] WHERE [AUDNC_TYPE].[audnc_type_actv_ind] = 'Y'" 
  #run the query
  resAudienceTypes <- runLMSQuery(query)
}


runLMSQuery <- function(query){
  #connect to the training db
  dbhandle <- odbcDriverConnect('driver={SQL Server};server=SQL\\SRVR;trusted_connection=true')
  #run the query
  res <- sqlQuery(dbhandle, query)
  #close the db connection
  close(dbhandle)
  #return the results
  res
}