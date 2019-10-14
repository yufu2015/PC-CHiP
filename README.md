![method outline](https://github.com/yufu2015/PathImaging/blob/master/readme.png)

# Pan-cancer quantitative histopathology analysis using deep learning

This directory contains the code to quantify histopathology features from H&E stained histopathology images using Inception-V4 in a Pan-cancer tissue classification setting.

The code is written in shell and python.


## External Prerequisites:
OpenCV
https://pypi.org/project/opencv-python/

Numpy
https://www.numpy.org/

OpenSlide
https://openslide.org/

tensorflow
https://www.tensorflow.org/install

Pre-trained Inception-V4
https://github.com/tensorflow/models/tree/master/research/slim

Re-trained Inception-V4 and re-trained altered Inception-V4
https://www.ebi.ac.uk/biostudies (study id: S-BSST292)

## Dataset

The histopathology images used are from TCGA (https://portal.gdc.cancer.gov/), open access to all. Only images from frozen tissue are included.

The dataset is composed with 42 normal and tumor tissue types from 28 cancers. Labels used in the classification can be found here /data/codebook.txt.

## How to use
Run inception/pipeline.sh (change relative paths)


  



