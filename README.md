# Yet Another TTS system (wip)

This project = Duration Model + Acoustic model + WaveRNN model

```
Duration model: Text => Phoneme duration
Acoustic model: Text + Phoneme => Speech features (melspectrogram + F0)
WaveRNN model : Speech features => Waveform
```

Current progress:
- Bootstrapping from `fatchord/WaveRNN` tacotron and wavernn models.


This project uses source code from following repositories:
- WaveRNN: https://github.com/fatchord/WaveRNN

## Installation

```sh
sudo apt update
sudo apt install -y pv sox
pip3 install -U pip
git clone https://github.com/NTT123/WaveRNN.git
cd WaveRNN
pip3 install -e .
```


## Training scripts

### Dev dataset (vietnamese-vivos-speaker35)

```sh
bash ./scripts/train_vivos35.sh 1 /tmp/vivs35 # stage 1, data directory /tmp/vivos35
```

### Reinfo dataset (vietnamese)

```sh
bash ./scripts/train_reinfo.sh 1 /tmp/reinfo # stage=1, data directory=/tmp/reinfo
```


### LJSpeech dataset (english)

```sh
bash ./scripts/train_ljs.sh 1 /tmp/ljs # stage=1, data directory=/tmp/ljs
```


