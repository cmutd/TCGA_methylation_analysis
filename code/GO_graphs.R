
GO_graphs <- function(input,bg,fileName,pngName){
  
  if(!file.exists(fileName)){
    kegg <- enrichKEGG(gene= input,
                       universe     = bg,
                       organism     = 'hsa',
                       pvalueCutoff = 0.05)	
    go<- enrichGO(input, OrgDb = "org.Hs.eg.db", ont="all") 
    save(kegg,go,file =fileName)
  }
  load(fileName)
  print("GO analysis is done")
  
  png(pngName, width = 465, height = 225, units='mm', res = 300)
  dot <- dotplot(kegg)
  bar <- barplot(go, split="ONTOLOGY",font.size =10)+ 
    facet_grid(ONTOLOGY~., scale="free") + 
    scale_x_discrete(labels=function(x) str_wrap(x, width=45))
	
  print ("Ready to generate graphs")
  graphs <- ggarrange(dot,bar,ncol=2, labels=c("A","B"))
  print(graphs)
  dev.off()
}
