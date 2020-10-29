library(data.table)
library(impute)
library(ChAMP)
library(stringr)
library(tibble)

options(stringsAsFactors = F)

if(!dir.exists("raw_data"))dir.create("raw_data")
if(!dir.exists("Rdata"))dir.create("Rdata")
if(!dir.exists("figure"))dir.create("figure")


### ============= step1: select tumor-normal paired samples (clinical data) ============ ### 
pd <- fread("raw_data/UCEC_clinicalMatrix",data.table = F)
pd <- pd[,c("sampleID","_PATIENT","sample_type")]; table(pd$sample_type)
pd <- pd[pd$sample_type%in% c("Primary Tumor","Solid Tissue Normal"), ]; table(pd$sample_type)

# select tumor-normal paired samples
samples <- intersect(pd$`_PATIENT`[pd$sample_type=="Primary Tumor"],pd$`_PATIENT`[pd$sample_type=="Solid Tissue Normal"])
pd <- pd[pd$`_PATIENT` %in% samples,]   #35



### ============= step2: preprocess methylation array data ============================= ### 
pre <- fread("raw_data/HumanMethylation450.gz",data.table=F)
pre <- column_to_rownames(pre,"sample")


# filter out samples have pd data 
pre_pd <- str_sub(colnames(pre),1,12)%in% pd$`_PATIENT`; sum(pre_pd)
meth_tmp <- pre[pre_pd]; dim(meth_tmp)


# select tumor-normal paired samples in methylation array data
patient <- str_sub(colnames(meth_tmp),1,12)
group <- ifelse(str_sub(colnames(meth_tmp),14,15)=="11","normal","tumor")
s <- intersect(patient[group=="normal"],patient[group=="tumor"])
meth_tmp <-meth_tmp[,patient%in%s]


pd <-pd[match(colnames(meth_tmp),pd$sampleID),]
identical(colnames(meth_tmp),pd$sampleID)

### ============= step3: generate ChAMP object ============================= ### 
beta <- as.matrix(meth_tmp)
beta=impute.knn(beta) 
sum(is.na(beta))

beta=beta$data
beta=beta+0.00001

myLoad=champ.filter(beta = beta ,pd = pd) 
dim(myLoad$beta)  #412481     66
save(myLoad,file = './Rdata/step1_myLoad.Rdata')
