##Set workign directory
setwd("D:\\Data Science Course\\Coursera-R-Programming_Course\\Getting and Cleaning Data\\week4\\Data")
library(dplyr)
library(tidyr)
df_X__Test_Total = NULL
df_X_Train_Total = NULL
df_Total = NULL
dfSubsetofTotal = NULL
dfSubsetofTotal2 = NULL
dfSubsetofTotal3 = NULL

##Step1.1: Read X_test, Y_test and Subject_test  data 
##and merge it into one block say test_block
dfy_test <- read.table(".\\y_test.txt",header = FALSE)
dfX_test <- read.table(".\\X_test.txt",header = FALSE)
dfSubject_test <- read.table(".\\subject_test.txt",header = FALSE)
df_X__Test_Total <- cbind(dfSubject_test,dfy_test,dfX_test)

##Step1.2: Read X_train, Y_train and Subject_train  data
##and merge it into one block say train_block
dfSubject_train <- read.table(".\\subject_train.txt",header = FALSE)
dfy_train <- read.table(".\\y_train.txt",header = FALSE)
dfX_train <- read.table(".\\X_train.txt",header = FALSE)
df_X_Train_Total <- cbind(dfSubject_train,dfy_train,dfX_train)

##Step 1.3 Combine test_block and train_block into one 
df_Total <- rbind(df_X__Test_Total, df_X_Train_Total)


##Step 2
##Extract only subject, activities,  and measuremnet columns 
##with mean and standarad names in it 

##Step1 2.1 read feature.txt and select columns with mean and std name
dfFeature <- read.table(".\\features.txt",header = FALSE)
vector_meanandstdcolumnNames <- grep("mean|std", dfFeature$V2)

##Step 2.2 cerate a subset of mean/std measures from the total measure 
dfSubsetofTotal <- df_Total[,vector_meanandstdcolumnNames]  
##dfSubsetofTotal[,2] <- lookUpVector[dfSubsetofTotal[,2]]
##Step 3. Change subset column names to more readable one
dfFeature$V2[ vector_meanandstdcolumnNames[1:77]]
colNAmestossign <- as.vector (dfFeature$V2[ vector_meanandstdcolumnNames])
X <- sub ("t", "time", colNAmestossign)  #replace first char "t" of the column name with time
y <- sub ("f", "freq", X) #replace first char "f" of the column name with freq

colNAmestossign <- y # more readable column names  name 


colnames(dfSubsetofTotal)[c(3:79)] <- colNAmestossign[1:77]
colnames(dfSubsetofTotal)[c(1:2)] <- c("Subject","Activity")

##Step4 remove punctuation marks from colnames 
##and substiture first t with time, and f with freq 
#gsub("[[:punct:]]","",colnames(dfSubsetofTotal)[c(3:79)])
##sub("f", "freq-",colnames(dfSubsetofTotal)[c(3:79)])

##Step 4.1. Group subset by SUbject and Activity using group_by
dfSubsetofTotal2 <- group_by(dfSubsetofTotal,Subject,Activity) 
#replace the NULL's with 0
dfSubsetofTotal2[is.null(dfSubsetofTotal2)] <- 0.0

##Step 5 mean of each measures. 
dfSubsetofTotal3 <- summarise_each(dfSubsetofTotal2,funs(mean), 3:77)

write.table(dfSubsetofTotal3, file = "MyTidyData.txt", row.names=FALSE)
 

