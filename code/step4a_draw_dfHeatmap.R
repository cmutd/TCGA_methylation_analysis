library(pheatmap)

rm(list=ls())
load("./Rdata/step2_filtered_pd_myNorm.Rdata")
load("./Rdata/step3_DMP.Rdata")


cg <- rownames(DMP_df[DMP_df$change!="NOT",])
matrix <- myNorm[cg,]


sample <- ifelse(pd$sample_type=="Primary Tumor","Tumor","Normal")
annotation_col <- data.frame(sample=sample)
rownames(annotation_col) <- colnames(matrix)
colors <- list(sample = c(Normal="#4DAF4A", Tumor="#E41A1C"))

pheatmap(matrix,show_colnames = F,
         annotation_col = annotation_col,
         color = colorRampPalette(colors = c("white","navy"))(50),
         annotation_colors = colors,show_rownames = F,
         filename="figure/DF_heatmap.png")
