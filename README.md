![method outline](https://github.com/yufu2015/PathImaging/blob/master/readme.png)

# Pan-Cancer Computational Histopathology (PC-CHiP) analysis using deep learning

This directory contains the code to quantify histopathology features from H&E stained histopathology images using Inception-V4 in a Pan-cancer tissue classification setting.

The code is written in shell and python.


## External Prerequisites:
OpenCV 4.1.1 
https://pypi.org/project/opencv-python/

Numpy 1.17.3 
https://www.numpy.org/

OpenSlide 3.4.1
https://openslide.org/

Python 3.4
https://www.python.org/

R 3.3.1
https://cran.r-project.org/ 

tensorflow 1.12
https://www.tensorflow.org/install

Pre-trained Inception-V4
https://github.com/tensorflow/models/tree/master/research/slim

Re-trained Inception-V4 and re-trained altered Inception-V4
https://www.ebi.ac.uk/biostudies (study id: S-BSST292)

Slim 
https://github.com/tensorflow/models/tree/master/research/slim

## Dataset

The histopathology images used in training are from TCGA (https://portal.gdc.cancer.gov/), open access to all. Only images from frozen tissue are included.

The histopathology images used in training are from METABRIC (https://ega-archive.org/dacs/EGAC00001000484), controlled access.

The dataset is composed with 42 normal and tumor tissue types from 28 cancers. Labels used in the classification can be found here /data/codebook.txt.

## How to use
Run inception/pipeline.sh (change relative paths)

## Citation
Pan-cancer computational histopathology reveals mutations, tumor composition and prognosis

Fu Y, Jung AW, Torne RV … Moore L, Gerstung M. BioRxiv, (2019 Oct 25). 

https://doi.org/10.1101/813543



