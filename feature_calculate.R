


## Compute Feature of PCL

library(lidR)
library(RANN)
library(rgl)
library(matlab)
library(tictoc)

# Read data
stem <- readLAS("stem.las")
nstem <- readLAS("nstem.las")
tic()


memory.limit(size=50000)




stem <- data.frame(cbind(stem@data$X,stem@data$Y,stem@data$Z))
nstem <- data.frame(cbind(nstem@data$X,nstem@data$Y,nstem@data$Z))
nstem$class <- 2L
stem$class <- 1L

data <- rbind(stem,nstem)

k <- 50
nearest <- nn2(data = data,k=k+1)
nn <- nearest[["nn.idx"]]
nn <- nn[,-1]
nn.dist <- nearest[["nn.dists"]]
nn.dist <- nn.dist[,-1]
pp <- as.matrix(data)

r_mat <- kronecker(matrix(1,k,1),pp[,1:3])
p_mat <- pp[nn,1:3]

p <-  p_mat - r_mat;
p <- matlab::reshape(p, size(pp,1), k, 3);


C <-  matrix(0,dim(data),6)
C[,1] <- rowSums(p[,,1]*p[,,1])
C[,2] <- rowSums(p[,,1]*p[,,2])
C[,3] <- rowSums(p[,,1]*p[,,3])
C[,4] <- rowSums(p[,,2]*p[,,2])
C[,5] <- rowSums(p[,,2]*p[,,3])
C[,6] <- rowSums(p[,,3]*p[,,3])
C <- C/k

###### normals and curvature calculation
normals <-  matrix(0,dim(pp),3)
curvature <-  matrix(0,dim(pp))
omnivariance <-  matrix(0,dim(pp))
planarity <-  matrix(0,dim(pp))
linearity <-  matrix(0,dim(pp))
surf_var <-  matrix(0,dim(pp))
anisotropy <-  matrix(0,dim(pp))
verticality <-  matrix(0,dim(pp))


for (i in 1:nrow(pp)) {
  #Covariance
  Cmat <- matrix( c(C[i,1], C[i,2], C[i,3],
                    C[i,2], C[i,4], C[i,5],
                    C[i,3], C[i,5], C[i,6]), byrow = TRUE,ncol = 3)  
  
  #Eigen values and vectors
  
  d <- eigen(Cmat)$values
  v <- eigen(Cmat)$vectors
  lambda  <- min(d);
  ind <- which(d==min(d))
  
  #store normals
  normals[i,] = t(v[,ind])
  if (normals[i,3]<0) {
    verticality[i,]= 1+normals[i,3]
  } else{
    verticality[i,]= 1-normals[i,3]
  }
  
  #store curvature
  curvature[i] = lambda / sum(d);
  
  #store omni
  omnivariance[i] = (d[1]*d[2]*d[3])^(1/3)
  #store planarity
  planarity[i] = (d[2]-d[3])/d[1]
  #store linearity
  
  linearity[i] = (d[1]-d[2])/d[1] 
  #store surf_var
  
  surf_var[i] = d[3]/(d[1]+d[2]+d[3])
  #store anisotropy
  
  anisotropy[i] = (d[1]-d[3])/d[1]
}



###### Flipping normals


#%% flipping normals
#%ensure normals point towards viewPoint
#viewPoint <- matrix(c(0,0,0),ncol = 3)
#pp[,1:3] = pp[,1:3] - kronecker(matrix(1,size(pp,1),1),viewPoint)
dist_nn <- nn.dist[,1]
write.csv(cbind(pp,normals,curvature,omnivariance,planarity,linearity,surf_var,anisotropy,verticality),file = "pcl_normals.txt")
toc()