rm(list=ls())
load("Rdata/step3_DMP.Rdata")


library(magrittr)
library(ggplot2)
library(ggrepel)
library(janitor)
library(cowplot)
library(tibble)


options(stringsAsFactors = FALSE)



data <-rownames_to_column(DMP_df,"Geneid")
data <- data[,c("Geneid","P.Value","deltaBeta","feature")]
rownames(data) <- data$Geneid

########### ======just select the first 2000 rows as an example =========#
data <- data[1:2000,]
#write.table(data,"input_dataset.txt",row.names = F,quote=F,sep='\t')



########### ====== Volcano plot (main)  ===============#
p1 <- ggplot(data, aes(deltaBeta, -log10(P.Value))) +
      geom_label_repel(aes(deltaBeta, -log10(P.Value),
                           label = ifelse(-log10(P.Value) > 38, rownames(data), "")))+
      geom_point(aes(color=feature))+
      guides(colour = guide_legend(override.aes = list(size=4.5)))+
      labs(x = "Methylation difference (beta-value)",
           y = bquote(~-log[10]~(italic("P-value"))))+theme_classic() 
 


########### ======= Volcano plot (right side) =========#
Percent <- data[, -1] %>%
  tabyl(feature) %>%
  adorn_totals("row") %>%
  adorn_pct_formatting() %>%
  .[-7,]     # remove row "Total"


n_max = max(Percent$n)


Percent$A <- 1:length(unique(data$feature))

# test dataset used for plot point
test = data.frame(x = c(1, 2, 3, 4, 5, 6),
                  y = rep(-n_max/15,6),  # the positon of points
                  type = LETTERS[1:6])

rect_data <- data.frame(
  xstart = c(0.55, 1.55, 2.55, 3.55, 4.55, 5.55),
  xend   = c(1.45, 2.45, 3.45, 4.45, 5.45, 6.45), 
  ystart = c(rep(-n_max/2, 6)),
  yend   = c(rep(0, 6)))


p2 <- ggplot(Percent, aes(A, n)) +
  geom_bar(stat = "identity", fill = "#BEBEBE", color = "black") + 
  geom_point(data = test, 
             aes(x, y, color = type), size = 4) +
  geom_text(aes(label = Percent$percent,
                hjust = ifelse(n > 1000, 2, -0.2)),   # 2,-0.2: up, right
            vjust = 0,
            fontface = "bold", size =3) +
  geom_text(data = Percent,
            aes(A, -n_max/3, label = c("1stExon", "3'UTR", "5'UTR", "Body", "TSS1500", "TSS200")), 
            color = "black", fontface = "bold",
            size = 3, hjust = 0.5) +
  geom_rect(data = rect_data, inherit.aes = FALSE,
            aes(xmin = xstart, xmax = xend,
                ymin = ystart, ymax = yend), 
            fill = "NA", color = "black") +
  coord_flip() +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0,0)) +

  
  theme(panel.background = element_rect(fill = NA),
        panel.border = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "none"
  ) +
  xlab("") + ylab("") 
p2



combined_plot <- insert_yaxis_grob(p1, p2, 
                                   position = "right",
                                   width = grid::unit(3, "in")
)


png("figure/step4c_Volcano_plot.png", width = 465, height = 225, units='mm', res = 300)

p <- plot_grid( combined_plot, ncol = 1, 
               rel_heights = c(0.1, 1)) 

p
dev.off()
