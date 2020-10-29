rm(list = ls())

#devtools::install_github("tomwenseleers/export")
library(ChAMP)
library(stringr)
library(FactoMineR)
library(factoextra)
library(pheatmap)
library(ggplotify)
library(ggpubr)

load('./Rdata/step1_myLoad.Rdata')
norm_file = "./Rdata/step2_champ_myNorm_raw.Rdata"



### ================= Step1: normalization ================ ### 

if(!file.exists(norm_file)){
  myNorm <- champ.norm(beta=myLoad$beta,arraytype="450K",cores=10)
  save(myNorm,file = norm_file)
}
load(norm_file)



### ================= Step2: clean data    ================ ### 

# generated new NA value after normalization 
num.na <- apply(myNorm,2,function(x)(sum(is.na(x))))
table(num.na)
hist(num.na)

# remove samples have NAs (along with their paired samples)
NAs <- names(num.na[num.na>0])
NA_pairs <- c(NAs, str_replace(NAs,"-01","-11"))

keep <- setdiff(colnames(myNorm),NA_pairs)

myNorm = myNorm[,keep]
pd = myLoad$pd
pd = pd[pd$sampleID %in% keep,]
identical(pd$sampleID,colnames(myNorm))


### ================= Step3a: QC (PCA)    ======================== ###
dat <- t(myNorm)
group <- pd$sample_type;table(group)

dat.pca <- PCA(dat, graph = FALSE) 
pca <- fviz_pca_ind(dat.pca,
             geom.ind = "point", 
             col.ind = group, 
             addEllipses = TRUE, 
             legend.title = "Groups")


### ================= Step3b: QC (heatmap) ======================== ###
cg=names(tail(sort(apply(myNorm,1,sd)),1000))

ann=data.frame(group=group)
rownames(ann)=colnames(myNorm)  
hm <- pheatmap(myNorm[cg,],show_colnames =F,show_rownames = F,
         annotation_col=ann)

cor <- pheatmap(cor(myNorm[cg,]),
                   annotation_col = ann,
                   show_rownames = F,
                    show_colnames = F)



### ================= Step3c: plot multiple figures in one  ======= ###
hm1 <- as.grob(hm)
cor1 <- as.grob(cor)

png("figure/qc_figures.png", width = 465, height = 225, units='mm', res = 300)
multi <- ggarrange(hm1,                                                 
          ggarrange(pca, cor1, ncol = 1,nrow = 2, labels = c("B", "C")),
          nrow = 1, 
          labels = "A"                    
)
multi

dev.off()

save(pd,myNorm,file="Rdata/step2_filtered_pd_myNorm.Rdata")
