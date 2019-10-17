from __future__ import absolute_import
from __future__ import division
from __future__ import print_function

import math
import os
import random
import sys


import tensorflow as tf
import dataset_utils

class ImageReader(object):
  """Helper class that provides TensorFlow image coding utilities."""

  def __init__(self):
    # Initializes function that decodes RGB JPEG data.
    self._decode_jpeg_data = tf.placeholder(dtype=tf.string)
    self._decode_jpeg = tf.image.decode_jpeg(self._decode_jpeg_data, channels=3)

  def read_image_dims(self, sess, image_data):
    image = self.decode_jpeg(sess, image_data)
    return image.shape[0], image.shape[1]

  def decode_jpeg(self, sess, image_data):
    image = sess.run(self._decode_jpeg,
                     feed_dict={self._decode_jpeg_data: image_data})
    assert len(image.shape) == 3
    assert image.shape[2] == 3
    return image


def _get_dataset_filename(output_dir, split_name, shard_id, NUM_SHARDS):
  output_filename = output_dir + 'images_%s_%05d-of-%05d.tfrecord' % (
      split_name, shard_id, NUM_SHARDS)
  return output_filename


def _convert_dataset(split_name, filenames, tps, Qs, classnames, classids, output_dir, NUM_SHARDS):
  """Converts the given filenames to a TFRecord dataset.
  Args:
    split_name: The name of the dataset, either 'train' or 'validation'.
    filenames: A list of absolute paths to png or jpg images.
    class_names_to_ids: A dictionary from class names (strings) to ids
      (integers).
    dataset_dir: The directory where the converted datasets are stored.
  """
  assert split_name in ['train', 'validation']

  num_per_shard = int(math.ceil(len(filenames) / float(NUM_SHARDS)))

  with tf.Graph().as_default():
    image_reader = ImageReader()

    with tf.Session('') as sess:

      for shard_id in range(NUM_SHARDS):
        output_filename = _get_dataset_filename(output_dir, split_name, shard_id, NUM_SHARDS)

        print (output_filename)
        with tf.python_io.TFRecordWriter(output_filename) as tfrecord_writer:
          start_ndx = shard_id * num_per_shard
          end_ndx = min((shard_id+1) * num_per_shard, len(filenames))
          for i in range(start_ndx, end_ndx):
            sys.stdout.write('\r>> Converting image %d/%d shard %d' % (
                i+1, len(filenames), shard_id))
            sys.stdout.flush()

            # Read the filename:
            print("reading file" + filenames[i])
            image_data = tf.gfile.FastGFile(filenames[i], 'rb').read()
            height, width = image_reader.read_image_dims(sess, image_data)
            class_id = classids[i]
            tp=tps[i]
            filename=filenames[i]
            Q=Qs[i]
            example = dataset_utils.image_to_tfexample(
                image_data, b'jpg', height, width, int(class_id), int(tp), filename, Q)
            tfrecord_writer.write(example.SerializeToString())

  sys.stdout.write('\n')
  sys.stdout.flush()

if __name__ == '__main__':
  
  if len(sys.argv) != 4:
    exit()

  file_info = sys.argv[1]
  output_dir = sys.argv[2]
  NUM_SHARDS = int(sys.argv[3])

  if output_dir[-1] != "/":
    output_dir += "/"
  if not os.path.exists(output_dir):
    os.makedirs(output_dir)

  image_filenames = []
  class_names = []
  class_ids = []
  tps = []
  Qs = []
  with open(file_info) as f:
    for line in f:
      l = line.split()
      image_filenames.append(l[0])
      class_names.append(l[1])
      class_ids.append(int(l[2]))
      tps.append(int(l[3]))
      Qs.append(l[4])

  # Divide into train and test:
  training_filenames = image_filenames
  training_classnames = class_names
  training_classids = class_ids

  # First, convert the training and validation sets.
  _convert_dataset('train', training_filenames, tps, Qs, training_classnames, training_classids,
                   output_dir, NUM_SHARDS)

  print('\nFinished converting dataset!')
  print('The converted data is stored in the directory: "' + output_dir + '"')
