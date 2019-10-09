#!/bin/bash
source /tensorflow/bin/activate
CurDir="$( cd "$(dirname "$0")" ; pwd -P )"

PRETRAINED_CHECKPOINT_DIR=$1
TRAIN_DIR=$2
DATASET_DIR=$3
dataset_name=$4
max_iter=$5

python $CurDir/../pythonScript/train_image_classifier.py \
  --train_dir=${TRAIN_DIR} \
  --dataset_name=$dataset_name \
  --dataset_split_name=train \
  --dataset_dir=${DATASET_DIR} \
  --model_name=inception_v4 \
  --checkpoint_path=${PRETRAINED_CHECKPOINT_DIR}/inception_v4.ckpt \
  --checkpoint_exclude_scopes=InceptionV4/Logits,InceptionV4/AuxLogits \
  --max_number_of_steps=$max_iter \
  --batch_size=32 \
  --learning_rate=0.01 \
  --save_interval_secs=100 \
  --save_summaries_secs=100 \
  --log_every_n_steps=300 \
  --optimizer=rmsprop \
  --weight_decay=0.00004 \
  --clone_on_cpu=False
