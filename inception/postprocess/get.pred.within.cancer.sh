input=$1
awk '{p1=0;
     if($2 ~ /TCGA_BRCA/){p1=2; p2=3};
     if($2 ~ /TCGA_COAD/){p1=5; p2=6};
     if($2 ~ /TCGA_ESCA/){p1=7;p2=8};
     if($2 ~ /TCGA_HNSC/){p1=10; p2=11};
     if($2 ~ /TCGA_KICH/){p1=12; p2=13};
     if($2 ~ /TCGA_KIRC/){p1=14; p2=15};
     if($2 ~ /TCGA_KIRP/){p1=16; p2=17};
     if($2 ~ /TCGA_LIHC/){p1=19; p2=20};
     if($2 ~ /TCGA_LUAD/){p1=21; p2=22};
     if($2 ~ /TCGA_LUSC/){p1=23; p2=24};
     if($2 ~ /TCGA_OV/){p1=26; p2=27};
     if($2 ~ /TCGA_PRAD/){p1=29; p2=30};
     if($2 ~ /TCGA_STAD/){p1=33; p2=34};
     if($2 ~ /TCGA_THCA/){p1=36; p2=37};
     isT="F";
     if(($2 ~ /normal/ && $(p1+8)>$(p2+8)) || ($2 !~ /normal/ && $(p1+8)<$(p2+8))){isT="T"};
     if(p1!=0){printf "%s %s %s %s %s %s %s\n", $1, $2, $6, $7, isT, $(p1+8), $(p2+8)}}' $input > $input.within.cancer

