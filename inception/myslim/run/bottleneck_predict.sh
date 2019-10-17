#!/bin/bash
source /tensorflow/bin/activate
CurDir="$( cd "$(dirname "$0")" ; pwd -P )"

TRAIN_DIR=$1
num_classes=$2
DATASET_DIR=$3
pred_out=$4
bot_out=$5
model_name=$6

echo $TRAIN_DIR 
echo $num_classes 
echo $DATASET_DIR 
echo $pred_out $bot_out

python $CurDir/../bottleneck_predict.py \
    --num_classes=$num_classes \
    --bot_out=$bot_out \
    --model_name=$model_name \
    --checkpoint_path=$TRAIN_DIR \
    --filedir=$DATASET_DIR \
    --eval_image_size=299
