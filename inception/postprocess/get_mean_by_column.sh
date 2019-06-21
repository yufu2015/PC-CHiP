
#input=$1
files=$(ls /gpfs/nobackup/gerstung/yu/TCGA/bottleneck/All/*txt | awk '{print $NF}')
for input in $files
do
    echo $file
    awk '{for(i=8;i<=1543;i++) {sum[i] += $i; sumsq[i] += ($i)^2}}                           
     END {for (i=8;i<=1543;i++) { printf "%f %f \n", sum[i]/NR, sqrt((sumsq[i]-sum[i]^2/NR)/NR)}}' $input > $input.all.m.sd
    awk 'BEGIN {n=0}
     {if($7=="T"){for(i=8;i<=1543;i++){sum[i] += $i; sumsq[i] += ($i)^2}; n+=1}}
     END {for(i=8;i<=1543;i++){printf "%f %f \n", sum[i]/n, sqrt((sumsq[i]-sum[i]^2/n)/n)}}' $input > $input.isT.m.sd   
    awk 'BEGIN {n=0}  
     {if(gsub("tumor", "normal", $2)==gsub("tumor", "normal", $4)){for(i=8;i<=1543;i++) {sum[i] += $i; sumsq[i] += ($i)^2}; n+=1}}
     END {for(i=8;i<=1543;i++) { printf "%f %f \n", sum[i]/n, sqrt((sumsq[i]-sum[i]^2/n)/n)}}' $input > $input.withinT.m.sd
done
