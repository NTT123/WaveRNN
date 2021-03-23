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
    # no trimming: silence -l 1 0.1 0.2% -1 0.1 0.2%"
    # echo "sox $filepath -b 16 -r 22050 -c 1 $data_dir/processed/$filename" 
    echo "cp $filepath $data_dir/processed/$filename" 
  done | pv -l -p -s 14935 -e -t | xargs -I CMD --max-procs=32 bash -c CMD
  find $data_dir/processed -name "*.wav" -type 'f' -size -44 -delete
  # remove unaligned clips
  rm $data_dir/processed/{00990,00991,08446,08620,10757,13070,13674,13727,14021}.wav
fi

if [ $stage -le 3 ]; then
  echo -e "\n==> stage 3: convert text to ljspeech format"
  cat $data_dir/raw/25hours/scripts.csv | awk  -F'([/|]|[.]wav)' '{print $3 "|" $5 }' > $data_dir/processed/prompts.csv
  cp ./fatchord_wavernn/assets/reinfo_silence_spaces.txt $data_dir/processed/prompts.csv
fi

if [ $stage -le 4 ]; then
  echo -e "\n==> stage 4: preprocess text and audio data"
  cp ./fatchord_wavernn/hparams.py $data_dir/processed/hparams.py

  cat <<EOT >> $data_dir/processed/hparams.py
# reinfo settings

sample_rate = 16000
hop_length = 200    # 12.5ms - in line with Tacotron 2 paper
win_length = 800    # 50ms - same reason as above


voc_model_id = 'reinfo_raw_16k'
tts_model_id = 'reinfo_lsa_attention_16k'
tts_cleaner_names = ['vie.vie_cleaners']

voc_mode = 'MOL'
voc_upsample_factors = (5, 5, 8)   # NB - this needs to correctly factorise hop_length


EOT

  python3 -m fatchord_wavernn.preprocess --hp_file=$data_dir/processed/hparams.py --path=$data_dir/processed
fi

if [ $stage -le 5 ]; then
  echo -e "\n==> stage 5: train tacotron text-to-mel model"
  python3 -m fatchord_wavernn.train_tacotron --hp_file=$data_dir/processed/hparams.py
fi 

if [ $stage -le 6 ]; then
  echo -e "\n==> stage 6: create ground truth aligned dataset (GTA)"
  python3 -m fatchord_wavernn.train_tacotron --hp_file=$data_dir/processed/hparams.py --force_gta
fi

if [ $stage -le 7 ]; then
  echo -e "\n==> stage 7: train WaveRNN vocoder model"
  python3 -m fatchord_wavernn.train_wavernn --hp_file=$data_dir/processed/hparams.py --gta
fi 

