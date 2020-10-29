rm(list = ls())
load(file = 'Rdata/step3_DMP.Rdata')
source("GO_graphs.R")

library(ggplot2)
library(stringr)
library(clusterProfiler)
library(org.Hs.eg.db)
library(ggpubr)


length(unique(DMP_df$gene))

entreID <- bitr(unique(DMP_df$gene), fromType = "SYMBOL",
                toType = c( "ENTREZID"),
                OrgDb = org.Hs.eg.db)

paste(
  round(length(setdiff(unique(DMP_df$gene),entreID$SYMBOL))/length(unique(DMP_df$gene)), 4)*100,
  "%","of input gene IDS are fail to map")

DMP_df <- merge(DMP_df,entreID,by.x="gene",by.y="SYMBOL")

UP_gene <- unique(DMP_df$ENTREZID[DMP_df$change=="UP"])
DOWN_gene <- unique(DMP_df$ENTREZID[DMP_df$change=="DOWN"])
DF_gene <- c(UP_gene,DOWN_gene)
all <- unique(DMP_df$ENTREZID)

############# ========= GO analysis of up-regulated gene ========= #############
input1 <- UP_gene
bg<- all
fileName1 <- "Rdata/UPGene_go.Rdata"
pngName1 <- "figure/UPGene_GOGraph.png"

UPGene_graph <- GO_graphs(input1,bg,fileName1,pngName1)



############# ========= GO analysis of down-regulated gene ========= #############
input2 <- Down_gene
fileName2 <- "Rdata/DownGene_go.Rdata"
pngName2 <- "figure/DownGene_GOGraph.png"
DownGene_graph <- GO_graphs(input2,bg,fileName2,pngName2)
