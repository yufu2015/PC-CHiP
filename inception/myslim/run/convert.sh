#!/bin/bash
source /tensorflow/tfgpu/bin/activate
CurDir="$( cd "$(dirname "$0")" ; pwd -P )"

file_info=$1
tfrecordDir=$2
num_shards=$3

python $CurDir/../pythonScript/convert.py $file_info $tfrecordDir $num_shards
