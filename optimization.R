  #### Optimization
  
  
  #veri2 <-  read.csv(file = "predict_lda_sor.csv")
  #veri2 <-  read.csv(file = "predict_logistic_sor.csv")
  #veri2 <-  read.csv(file = "predict_svm_sor.csv")
  veri2 <-  read.csv(file = "predict_rf_sor.csv")
  
  veri2 <- veri2[,1:4]
  #colnames(veri2) <- c("X","Y","Z","Class", "nx","ny", "nz", "Curvature",
   #                    "Omnivariance","Planarity", "Linearity", "Surface_Variance","Anisotropy", "Verticality")
  colnames(veri2) <- c("X","Y","Z","Class")
  
  veri2 <- data.frame(veri2)
  veri5 <- data.frame()
  veri6 <- data.frame()
  
  library(MASS)
  library(rgl)
  veri3 <- veri2[veri2$Class==1,]
  
  rgl.open() # Open a new RGL device
  rgl.points(veri3$X, veri3$Y, veri3$Z, color ="lightgray") # Scatter plot
  #minz <- min(veri3$Z)
  maxz <- max(veri3$Z)
  minz <- 0
  maxz <- 10
  interval <- seq(from=minz, to=maxz, by=1)
  store = list()
  for (i in interval) {
    print(i)
  #i=0
  veri4 <- veri3[veri3$Z>i & veri3$Z< i+1,1:3]
  rgl.open() # Open a new RGL device
  rgl.points(veri4$X, veri4$Y, veri4$Z, color ="lightgray") # Scatter plot
  
  xc<-mean(veri4$X);yc<-mean(veri4$Y)
  x <- veri4$X; y<- veri4$Y
    foo <- function(x1,y1,xc,yc) sum(sqrt((x1-xc)^2+(y1-yc)^2))
    dist <- mapply(foo,x,y,xc,yc)
  MAD <- mad(dist,na.rm = TRUE)
  sd <- sd(dist,na.rm = TRUE)
  #store <- densityMclust(veri4)
  #plot(store)
  if (sd>0.05) {
    print("MCLUST calisiyor..")
    library(mclust)
    mod1 <- Mclust(veri4, G=2)
    #summary(mod1, parameters = TRUE)
    #plot(mod1, what="density")
    #plot(mod1, what="classification")
    # rgl.open()
    #rgl.points(veri4$X[mod1$classification==1],veri4$Y[mod1$classification==1],veri4$Z[mod1$classification==1])
  
     veri5 <- cbind(veri4$X[mod1$classification==1],veri4$Y[mod1$classification==1],veri4$Z[mod1$classification==1])
     filename1 <- paste("stem_optimized_rf", i ,".csv",sep = "-")
     write.csv(veri5, file = filename1)
     print("nstem_optimized writing to file..")
     veri6 <- cbind(veri4$X[mod1$classification==2],veri4$Y[mod1$classification==2],veri4$Z[mod1$classification==2])
     filename2 <- paste("nstem_optimized_rf", i ,".csv",sep = "-")
     write.csv(veri6, file = filename2)
  } else {
    print("Optimizing not necessary for this section...")
    filename3 <- paste("non_optimized_rf", i ,".csv",sep = "-")
    write.csv(veri4, file = filename3)
  }
  }






