

# TCGA_methylation

---

Date: 10/28/2020

---


# 1. Data source

* <a href="https://xenabrowser.net/datapages/?dataset=TCGA.UCEC.sampleMap%2FHumanMethylation450&host=https%3A%2F%2Ftcga.xenahubs.net&removeHub=https%3A%2F%2Fxena.treehouse.gi.ucsc.edu%3A443" _target="blank">Methylation 450k</a>
* <a href="https://xenabrowser.net/datapages/?dataset=TCGA.UCEC.sampleMap%2FUCEC_clinicalMatrix&host=https%3A%2F%2Ftcga.xenahubs.net&removeHub=https%3A%2F%2Fxena.treehouse.gi.ucsc.edu%3A443" _target="blank"> Clinical data</a>

Data source: <a href="https://xenabrowser.net/datapages/" _target="blank" > UCSC Xena </a>



## 2.  Quality control 

<a href="https://github.com/cmutd/TCGA_methylation_analysis/blob/main/code/step2_qc_filter.R" _target="blank"> Code</a>





## 3. Differentially methylated Probe analysis

<a href="" _target="blank"> Code</a>



## 4a. Downstream analysis - heatmap plot 

<a href="" _target="blank"> Code</a>







## 4b. Downstream anlysis - GO analysis

<a href="" _target="blank"> Code </a>

![DownGene_GOGraph](C:\Users\mchen11\Desktop\TCGA_methylation\figure\DownGene_GOGraph.png)![UPGene_GOGraph](C:\Users\mchen11\Desktop\TCGA_methylation\figure\UPGene_GOGraph.png)



## 4c. Downstream anlysis - Volcano Plot 

<a href="" _target="blank"> Code </a>

![step4c_Volcano_plot](C:\Users\mchen11\Desktop\TCGA_methylation\figure\step4c_Volcano_plot.png)



## 5. Reference

1. Cannot convert object of class pheatmap into a grob

   <a href="https://rdrr.io/cran/ggplotify/man/as-grob.html" _target="blank"> as-grob</a>

2. Mix multiple graphs on the same page

   <a href="http://www.sthda.com/english/articles/24-ggpubr-publication-ready-plots/81-ggplot2-easy-way-to-mix-multiple-graphs-on-the-same-page/" _target="blank">ggpurb </a>

3. Save high resolution plot in png

   <a href="https://stackoverflow.com/questions/51192059/saving-high-resolution-plot-in-png" _target="blank"> Saving high resolution plot in png format</a>

4. Janitor package

   <a href="https://garthtarr.github.io/meatR/janitor.html"  _target="blank"> Janitor</a>



