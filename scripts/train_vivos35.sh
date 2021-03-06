#!/bin/bash

stage=${1:-1}
data_dir=${2:-/tmp/vivos35}
mkdir -p $data_dir/{raw,processed}

if [ $stage -le 1 ]; then
  echo -e "\n==> stage 1: download and unpack data"
  wget -q --show-progress https://www.dropbox.com/s/nzjh799e3afvy3p/vivos.zip?dl=1 -O $data_dir/raw/vivos.zip
  unzip -qo $data_dir/raw/vivos.zip -d $data_dir/raw
fi

if [ $stage -le 2 ]; then
  echo -e "\n==> stage 2: resample and normalize audio clips"
  find $data_dir/raw/vivos -name "*.wav" | while read filepath; do
    filename=$(basename $filepath)
    sox --norm=-5 $filepath -b 16 -r 22050 -c 1 $data_dir/processed/$filename 
  done
  rm $data_dir/processed/VIVOSSPK35_262.wav # bad sample
fi

if [ $stage -le 3 ]; then
  echo -e "\n==> stage 3: convert text to ljspeech format"
  cat $data_dir/raw/vivos/prompts.txt | grep VIVOSSPK35 | awk '{print $1 "|" substr($0, index($0,$2)) }' > $data_dir/processed/prompts.csv
fi

if [ $stage -le 4 ]; then
  echo -e "\n==> stage 4: preprocess text and audio data"
  cp ./fatchord_wavernn/hparams.py $data_dir/processed/hparams.py

  cat <<EOT >> $data_dir/processed/hparams.py
# vivos35 settings
tts_schedule = [(7,  1e-3,  10_000,  2),  
                (5,  1e-4, 100_000,  2),
                (2,  1e-4, 180_000,  2),
                (2,  1e-4, 350_000,  2)]
voc_batch_size = 2                
voc_model_id = 'vivos35_mol'
tts_model_id = 'vivos35_lsa_smooth_attention'

EOT

  python3 -m fatchord_wavernn.preprocess --hp_file=$data_dir/processed/hparams.py --path=$data_dir/processed
fi

if [ $stage -le 5 ]; then
  echo -e "\n==> stage 5: train tacotron text-to-mel model"
  python3 -m fatchord_wavernn.train_tacotron --hp_file=$data_dir/processed/hparams.py
fi 

if [ $stage -le 6 ]; then
  echo -e "\n==> stage 6: train WaveRNN vocoder model"
  python3 -m fatchord_wavernn.train_wavernn --hp_file=$data_dir/processed/hparams.py
fi 