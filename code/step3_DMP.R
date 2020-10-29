library(ChAMP)
library(tibble)

rm(list=ls())
load("./Rdata/step2_filtered_pd_myNorm.Rdata")

group <- ifelse(pd$sample_type=="Primary Tumor","tumor","normal")
myDMP <- champ.DMP(beta = myNorm,pheno=group)

DMP_df <- myDMP$tumor_to_normal;dim(DMP_df)
DMP_df <- DMP_df[DMP_df$gene!="",];dim(DMP_df)

logFC_t <- 0.45
P.Value_t <- 10^-15
DMP_df$change <- ifelse(DMP_df$adj.P.Val < P.Value_t & abs(DMP_df$logFC) > logFC_t,
                        ifelse(DMP_df$logFC > logFC_t ,'UP','DOWN'),'NOT') 
table(DMP_df$change) 
save(DMP_df,file = "Rdata/step3_DMP.Rdata")


