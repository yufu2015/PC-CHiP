#!/bin/bash
CurDir="$( cd "$(dirname "$0")" ; pwd -P )"
OutputDir="/tmp/outputdir"

#### image tiling ####
# tiles will be saved under $OutputDir/tiles with name $imgID_posX_posY.jpg

python preprocess/imgconvert.py $PATH2img $imgID $OutputDir/tiles 

#### convert images to tfrecord ####
#file_info_train: //path to tiles//label//code of label//tumor purity(-100 for normal); sep by space
#codebook.txt: //cancer//tissue//code; sep by space

tfrecordDir=$OutputDir/process_train
mkdir -p $tfrecordDir
bash $CurDir/myslim/run/convert.sh $OutputDir/file_info_train $tfrecordDir 320

tfrecordDir=$OutputDir/process_test
mkdir -p $tfrecordDir
bash $CurDir/myslim/run/convert.sh $OutputDir/file_info_test $tfrecordDir 320

#### train network ####
# download pretrained Inception-V4 to $CurDir/myslim/checkpoint and decompress
# change dataset info in dataset/tumors_all.py, notebly number of training and validation images
 
PRETRAINED_CHECKPOINT_DIR=$CurDir/myslim/checkpoint
DATASET_DIR=$OutputDir/process_train
TRAIN_DIR=$OutputDir/result_v4
bash $CurDir/myslim/run/load_inception_v4.sh $PRETRAINED_CHECKPOINT_DIR $TRAIN_DIR $DATASET_DIR tumors_all 20000

#### do evaluation ####

bash $CurDir/myslim/run/eval.sh $TRAIN_DIR $OutputDir/process_train tumors_all inception_v4
bash $CurDir/myslim/run/eval.sh $TRAIN_DIR $OutputDir/process_test tumors_all inception_v4

#### compute predictions and bottlenecks ####

bash $CurDir/myslim/run/bottleneck_predict.sh $TRAIN_DIR 42 $OutputDir/process_train $OutputDir/pred.train.txt $OutputDir/bot.train.txt
bash $CurDir/myslim/run/bottleneck_predict.sh $TRAIN_DIR 42 $OutputDir/process_test $OutputDir/pred.test.txt $OutputDir/bot.test.txt

#### transform bottleneck feautres // add dummy variable for tissue type for each tile // save predictions in seperate files ####
#output: $OutputDir/bot.*.txt.info // $OutputDir/bot.*.txt.pred

bash $CurDir/postprocess/bot.transform.sh $OutputDir/bot.train.txt
bash $CurDir/postprocess/bot.transform.sh $OutputDir/bot.test.txt

#### get prediction within cancer type (instead of among 42 tissues) #####

bash $CurDir/postprocess/get.pred.within.cancer.sh $OutputDir/bot.train.txt.pred
bash $CurDir/postprocess/get.pred.within.cancer.sh $OutputDir/bot.test.txt.pred

#### train altered inception_v4 network ####

PRETRAINED_CHECKPOINT_DIR=$CurDir/myslim/checkpoint
DATASET_DIR=$OutputDir/process_train
TRAIN_DIR=$OutputDir/result_v4_v2
bash $CurDir/myslim/run/load_inception_v4_alt.sh $PRETRAINED_CHECKPOINT_DIR $TRAIN_DIR $DATASET_DIR tumors_all 20000

# same scripts for down stream analysis 
