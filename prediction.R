### Predict new PCL

#superModel <- readRDS("./model_logistic.rds")
#superModel <- readRDS("./model_svm.rds")
superModel <- readRDS("./model_rf.rds")

print(superModel)

veri2 <-  read.csv(file = "pcl_normals.txt")
colnames(veri2) <- c("ID","X","Y","Z","Class", "nx","ny", "nz", "Curvature",
                     "Omnivariance","Planarity", "Linearity", "Surface_Variance","Anisotropy", "Verticality")

veri2$Class <- 0
finalPredictions <- predict(superModel, veri2)
#confusionMatrix(finalPredictions, veri2$Class)
export<-veri2
export$Class <- finalPredictions
export$Class <- as.numeric(as.character(export$Class))

write.csv(export, "./predict_rf.csv")
