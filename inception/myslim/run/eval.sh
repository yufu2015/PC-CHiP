#!/bin/bash
source /tensorflow/bin/activate
CurDir="$( cd "$(dirname "$0")" ; pwd -P )"

TRAIN_DIR=$1
DATASET_DIR=$2
dataset_name=$3
model_name=$4

python $$CurDir/../pythonScript/eval_image_classifier.py \
    --alsologtostderr \
    --checkpoint_path=$TRAIN_DIR \
    --dataset_dir=$DATASET_DIR \
    --dataset_name=$dataset_name \
    --dataset_split_name=train \
    --model_name=$model_name
