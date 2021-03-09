#!/bin/bash

stage=${1:-1}
data_dir=${2:-/tmp/ljspeech}
mkdir -p $data_dir/{raw,processed}
URL="https://data.keithito.com/data/speech/LJSpeech-1.1.tar.bz2"

if [ $stage -le 1 ]; then
  echo -e "\n==> stage 1: download and unpack data"
  if [ ! -f $data_dir/raw/LJSpeech-1.1.tar.bz2 ]; then
    wget -q --show-progress $URL -O $data_dir/raw/LJSpeech-1.1.tar.bz2
  fi
  tar -xjf $data_dir/raw/LJSpeech-1.1.tar.bz2 -C $data_dir/raw
fi

if [ $stage -le 2 ]; then
  echo -e "\n==> stage 2: copy hparams.py and preprocess data"
  cp ./fatchord_wavernn/hparams.py $data_dir/processed/hparams.py

  cat <<EOT >> $data_dir/processed/hparams.py
# LJSpeech settings
voc_model_id = 'ljspeech_mol'
tts_model_id = 'ljspeech_lsa_smooth_attention'
tts_cleaner_names = ['eng.english_cleaners']
EOT

  python3 -m fatchord_wavernn.preprocess --hp_file=$data_dir/processed/hparams.py --path=$data_dir/raw/LJSpeech-1.1
fi

if [ $stage -le 3 ]; then
  echo -e "\n==> stage 3: train tacotron text-to-mel model"
  python3 -m fatchord_wavernn.train_tacotron --hp_file=$data_dir/processed/hparams.py
fi 


if [ $stage -le 4 ]; then
  echo -e "\n==> stage 4: create ground truth aligned dataset (GTA)"
  python3 -m fatchord_wavernn.train_tacotron --hp_file=$data_dir/processed/hparams.py --force_gta
fi

if [ $stage -le 5 ]; then
  echo -e "\n==> stage 5: train WaveRNN vocoder model"
  python3 -m fatchord_wavernn.train_wavernn --hp_file=$data_dir/processed/hparams.py --gta
fi 

