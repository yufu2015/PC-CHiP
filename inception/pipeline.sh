#!/bin/bash
CurDir="$( cd "$(dirname "$0")" ; pwd -P )"
OutputDir="/tmp/outputdir"

############################
# convert images to tfrecord
#############################
#file_info_train: //path to tiles//label//code of label//tumor purity(-100 for normal); sep by space
#codebook.txt: //cancer//tissue//code; sep by space

tfrecordDir=$OutputDir/process_train
mkdir -p $tfrecordDir
bash $CurDir/myslim/run/convert_ls.sh $OutputDir/file_info_train $tfrecordDir 320

tfrecordDir=$OutputDir/process_validation
mkdir -p $tfrecordDir
bash $CurDir/myslim/run/convert_ls.sh $OutputDir/file_info_validation $tfrecordDir 320

############################
# train network
############################

PRETRAINED_CHECKPOINT_DIR=$CurDir/myslim/checkpoint
DATASET_DIR=$OutputDir/process_train
TRAIN_DIR=$OutputDir/result_v4
bash $CurDir/myslim/run/load_inception_v4.sh $PRETRAINED_CHECKPOINT_DIR $TRAIN_DIR $DATASET_DIR tumors_all 20000

###########################                                                                                                     
# do evaluation
############################
bash $CurDir/myslim/run/eval.sh $TRAIN_DIR $OutputDir/process_train tumors_all inception_v4
bash $CurDir/myslim/run/eval.sh $TRAIN_DIR $OutputDir/process_validation tumors_all inception_v4

############################
# compute predictions and bottlenecks 
############################

bash $CurDir/myslim/run/bottleneck_predict.sh $TRAIN_DIR 42 $OutputDir/process_train $OutputDir/pred.train.txt $OutputDir/bot.train.txt
bash $CurDir/myslim/run/bottleneck_predict.sh $TRAIN_DIR 42 $OutputDir/process_validation $OutputDir/pred.validation.txt $OutputDir/bot.validation.txt
bash $CurDir/myslim/run/bottleneck_predict.sh $TRAIN_DIR 42 $OutputDir/process_test $OutputDir/pred.test.txt $OutputDir/bot.test.txt

