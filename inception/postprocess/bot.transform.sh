input=$1

truncate -s 0 $input.pred
truncate -s 0 $input.info

awk -v out1=$input.pred -v out2=$input.info '
{n=split($1, a, "/");                                                                                        
split(a[n], aa, "_");                                                                                       
split(a[n], b, "-");                                                                                        
if(substr(b[4], 1, 2)!="11"){tv=a[6]"_tumor"}else{tv=a[6]"_normal"};                                        
max=$3; pm=0; for(i=4;i<=44;i++){if($i>max){max=$i; pm=i-3}};
if($2==pm){isT="T"}else{isT="F"};                                                                           
if(pm==0){pred="TCGA_ACC_tumor"};                                                                        
if(pm==1){pred="TCGA_BLCA_tumor"};                                                                       
if(pm==2){pred="TCGA_BRCA_normal"};                                                                      
if(pm==3){pred="TCGA_BRCA_tumor"};                                                                       
if(pm==4){pred="TCGA_CESC_tumor"};                                                                       
if(pm==5){pred="TCGA_COAD_normal"};                                                                      
if(pm==6){pred="TCGA_COAD_tumor"};                                                                       
if(pm==7){pred="TCGA_ESCA_normal"};                                                                      
if(pm==8){pred="TCGA_ESCA_tumor"};                                                                       
if(pm==9){pred="TCGA_GBM_tumor"};                                                                        
if(pm==10){pred="TCGA_HNSC_normal"};                                                                     
if(pm==11){pred="TCGA_HNSC_tumor"};                                                                      
if(pm==12){pred="TCGA_KICH_normal"};                                                                     
if(pm==13){pred="TCGA_KICH_tumor"};                                                                      
if(pm==14){pred="TCGA_KIRC_normal"};                                                                     
if(pm==15){pred="TCGA_KIRC_tumor"};                                                                      
if(pm==16){pred="TCGA_KIRP_normal"};                                                                     
if(pm==17){pred="TCGA_KIRP_tumor"};                                                                      
if(pm==18){pred="TCGA_LGG_tumor"};                                                                       
if(pm==19){pred="TCGA_LIHC_normal"};                                                                     
if(pm==20){pred="TCGA_LIHC_tumor"};                                                                      
if(pm==21){pred="TCGA_LUAD_normal"};                                                                     
if(pm==22){pred="TCGA_LUAD_tumor"};                                                                      
if(pm==23){pred="TCGA_LUSC_normal"};                                                                     
if(pm==24){pred="TCGA_LUSC_tumor"};                                                                      
if(pm==25){pred="TCGA_MESO_tumor"};                                                                      
if(pm==26){pred="TCGA_OV_normal"};                                                                       
if(pm==27){pred="TCGA_OV_tumor"};                                                                        
if(pm==28){pred="TCGA_PCPG_tumor"};                                                                      
if(pm==29){pred="TCGA_PRAD_normal"};                                                                     
if(pm==30){pred="TCGA_PRAD_tumor"};                                                                      
if(pm==31){pred="TCGA_READ_tumor"};                                                                      
if(pm==32){pred="TCGA_SARC_tumor"};                                                                      
if(pm==33){pred="TCGA_STAD_normal"};                                                                     
if(pm==34){pred="TCGA_STAD_tumor"};                                                                      
if(pm==35){pred="TCGA_TGCT_tumor"};                                                                      
if(pm==36){pred="TCGA_THCA_normal"};                                                                     
if(pm==37){pred="TCGA_THCA_tumor"};                                                                      
if(pm==38){pred="TCGA_THYM_tumor"};                                                                      
if(pm==39){pred="TCGA_UCEC_tumor"};                                                                      
if(pm==40){pred="TCGA_UVM_tumor"};                                                                       
if(pm==41){pred="TCGA_SKCM_tumor"};                                                                      
printf "%s %s %s %s %s %s %s", a[n-1]"_"aa[2]"_"aa[3], tv, $2, pred, pm, $(pm+3), isT >> out1;
for(i=3;i<=44;i++){printf " %s", $i >> out1};
printf "\n" >> out1;
printf "%s %s %s %s %s %s %s", a[n-1]"_"aa[2]"_"aa[3], tv, $2, pred, pm, $(pm+3), isT >> out2; 
for(i=45;i<=NF;i++){printf " %s", $i >> out2};
for(i=1;i<=41;i++){if(i==$2){printf " 1" >> out2}else{printf " 0" >> out2}}; 
printf "\n" >> out2;
close(out1);
close(out2)}' $input 
