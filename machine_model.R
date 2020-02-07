

## Machine learning Model

library(caret)
library(ellipse)
library(e1071)
library(kernlab)
library(randomForest)
library(rgl)
library(spatstat)
library(parallel)
library(doParallel)
library(tictoc)

cluster <- makeCluster(detectCores() - 1) # convention to leave 1 core for OS
registerDoParallel(cluster)
veri2 <- read.csv(file = "pcl_normals.txt")
#veri2 <- cbind(pp,normals,curvature,omnivariance,planarity,linearity,surf_var,anisotropy,dist_nn)
colnames(veri2) <- c("ID","X","Y","Z","Class", "nx","ny", "nz", "Curvature",
                     "Omnivariance","Planarity", "Linearity", "Surface_Variance","Anisotropy","Verticality")

class(veri2)
#SAmple data
veri2<- veri2[sample(nrow(veri2), 10000), ]

#veri2 <- as.data.frame(veri2)
#### Validation ###
validation_index <- createDataPartition(veri2$Class, p=0.7,list = FALSE)
validation <- veri2[-validation_index,]
validation$Class <- factor(validation$Class)
dataset <- veri2[validation_index,]

####### Dimensions of the dataset #####
dataset$Class <- factor(dataset$Class)
dim(dataset)
sapply(dataset, class)
head(dataset)
levels(dataset$Class)

####### Building Models #######
tic()
control <- trainControl(method = "cv",number = 10, allowParallel = TRUE)
metric <- "Accuracy"

set.seed(7)
#fit.rf <- train(Class~ nx+ny+nz+Curvature + Omnivariance + Planarity + 
#                 Linearity + Surface_Variance + Anisotropy, data = na.omit(dataset), method = "rf",
#               metric = metric, trControl = control)



## LDA
# fit.lda <- train(Class~ nx + ny + nz + Curvature + Omnivariance + Planarity + Linearity
#                 + Surface_Variance + Anisotropy + Verticality, data = na.omit(dataset), method = "lda",
#                 metric = metric, trControl = control)
# toc()
# summary(fit.lda)
# print(fit.lda)
## Bayes Logistic Regression
# fit.logistic <- train(Class~ nx + ny + nz + Curvature + Omnivariance + Planarity + Linearity
#                  + Surface_Variance + Anisotropy + Verticality, data = na.omit(dataset), method = "bayesglm",
#                  metric = metric, trControl = control)
# toc()
#summary(fit.logistic)
#print(fit.logistic)
### SVM
# fit.svm <- train(Class~ nx + ny + nz + Curvature + Omnivariance + Planarity + Linearity
#                       + Surface_Variance + Anisotropy + Verticality, data = na.omit(dataset), 
#                       method = "svmLinear",
#                       metric = metric, trControl = control)
### RF
fit.rf <- train(Class~ nx + ny + nz + Curvature + Omnivariance + Planarity + Linearity
                 + Surface_Variance + Anisotropy + Verticality, data = na.omit(dataset), 
                 method = "rf",
                 metric = metric, trControl = control)
toc()



#summary(fit.svm)
#print(fit.svm)

stopCluster(cluster)
registerDoSEQ()

summary(fit.rf)
print(fit.rf)
##### Make Predictions #######
predictions <- predict(fit.rf, validation)
result <- confusionMatrix(predictions, validation$Class, mode = "everything")
result

# predictions <- predict(fit.svm, validation)
# result <- confusionMatrix(predictions, validation$Class, mode = "everything")
# result
## Logistic
# predictions <- predict(fit.logistic, validation)
# result <- confusionMatrix(predictions, validation$Class, mode = "everything")
# result
# saveRDS(fit.logistic, "./model_logistic.rds")
## Logistic
# predictions <- predict(fit.svm, validation)
# result <- confusionMatrix(predictions, validation$Class, mode = "everything")
# result
saveRDS(fit.rf, "./model_rf.rds")
