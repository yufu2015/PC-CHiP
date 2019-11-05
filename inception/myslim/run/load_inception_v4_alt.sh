#!/bin/bash
source /tensorflow/bin/activate
CurDir="$( cd "$(dirname "$0")" ; pwd -P )"

PRETRAINED_CHECKPOINT_DIR=$1
TRAIN_DIR=$2
DATASET_DIR=$3
dataset_name=$4
max_iter=$5

python $CurDir/../train_image_classifier_jpeg.py \
  --train_dir=${TRAIN_DIR} \
  --train_image_size=299 \
  --dataset_name=$dataset_name \
  --dataset_split_name=train \
  --dataset_dir=${DATASET_DIR} \
  --model_name=inception_v4_alt \
  --checkpoint_path=${PRETRAINED_CHECKPOINT_DIR}/model.ckpt-100000 \
  --checkpoint_exclude_scopes=InceptionV4/Logits,InceptionV4/AuxLogits \
  --max_number_of_steps=$max_iter \
  --batch_size=32 \
  --learning_rate=0.01 \
  --learning_rate_decay_type=exponential \
  --save_interval_secs=600 \
  --save_summaries_secs=600 \
  --log_every_n_steps=300 \
  --optimizer=rmsprop \
  --weight_decay=0.00004 \
  --clone_on_cpu=False \
  --label_smoothing=0.1 \
  --num_epochs_per_decay=20 


