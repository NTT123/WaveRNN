#!/bin/bash

stage=${1:-1}
data_dir=${2:-/tmp/reinfo}
mkdir -p $data_dir/{raw,processed}

if [ $stage -le 1 ]; then
  echo -e "\n==> stage 1: download and unpack data"
  if [ ! -f $data_dir/raw/25hours.zip ]; then
    wget -q --show-progress https://files.huylenguyen.com/25hours.zip -O $data_dir/raw/25hours.zip
  fi
  unzip -P BroughtToYouByInfoRe $data_dir/raw/25hours.zip -d $data_dir/raw
fi

if [ $stage -le 2 ]; then
  echo -e "\n==> stage 2: resample and normalize audio clips"
  find $data_dir/raw/ -name "*.wav" | while read filepath; do
    filename=$(basename $filepath)
    echo "sox --norm=-5 $filepath -b 16 -r 22050 -c 1 $data_dir/processed/$filename silence 1 0.1 1%"
  done | pv -l -p -s 14935 -e -t | xargs -I CMD --max-procs=32 bash -c CMD
  find $data_dir/processed -name "*.wav" -type 'f' -size -44 -delete
fi

if [ $stage -le 3 ]; then
  echo -e "\n==> stage 3: convert text to ljspeech format"
  cat $data_dir/raw/25hours/scripts.csv | awk  -F'([/|]|[.]wav)' '{print $3 "|" $5 }' > $data_dir/processed/prompts.csv
fi

if [ $stage -le 4 ]; then
  echo -e "\n==> stage 4: preprocess text and audio data"
  cp ./fatchord_wavernn/hparams.py $data_dir/processed/hparams.py

  cat <<EOT >> $data_dir/processed/hparams.py
# reinfo settings
voc_model_id = 'reinfo_mol'
tts_model_id = 'reinfo_lsa_smooth_attention'
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

