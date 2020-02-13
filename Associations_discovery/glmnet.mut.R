library("methods")
library("glmnet")

wtParam<-function(model, outfile){
        dt=data.frame(cvm=model$cvm,
                      cvlo=model$cvlo,
                      cvup=model$cvup,
                      lambda=model$lambda)
        write.table(dt, file=outfile, append=F, sep = "\t", row.names=F, quote=F)
        coef=coef(model, s = "lambda.min")
        p=which(coef!=0)
        write.table(coef[p,], file=outfile, append=TRUE, sep = "\t", quote=F)}

args=(commandArgs(TRUE))
outputdir=args[1]
gene=args[2]
n=args[3]

setwd(outputdir)
print(n)
indice=c(0:4)[-as.numeric(n)]

datadir=dirname(outputdir)

X=Y=NULL
for(i in indice){
print(i)
inputX=paste(datadir, "/bot.train.file.", i, sep="")
inputY=paste(datadir, "/train.txt.", i, sep="")

x=read.csv(inputX, sep=" ", h=F, as.is=T)
y=read.csv(inputY, sep=" ", h=F, as.is=T)

X=rbind(X, x)
Y=rbind(Y,y)
}
print("read table done")

#remove NA in y
p=which(is.na(Y$V2)==F)
x=X[p, ]
y=Y[p, ]
rm(list=c("X", "Y"))
print(c(dim(x)[1:2], dim(y)[1:2]))

# cv split by patient id
pd=substr(x$V1, 1, 12)
pd1=sort(unique(pd[which(y$V2==0)]))
pd2=sort(unique(pd[which(y$V2==1)]))
dic=c(rep(1:10, 10000)[1:length(pd1)],
      rep(1:10, 10000)[1:length(pd2)])
names(dic)=c(pd1, pd2)
splits=dic[substr(x$V1, 1, 12)]

nc=ncol(x)
nm=nc-1576
model_all=cv.glmnet(as.matrix(x[,c(nm:nc)]), y$V2, foldid=splits, nfold=10, family="binomial",type.measure="auc")
wtParam(model_all, paste(gene, ".model_all.param.foldid.txt", sep=""))
save(model_all, file=paste(gene, ".model_all.foldid.rd", sep=""))
