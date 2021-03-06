# A complete TTS system

This project = Duration Model + Acoustic model + WaveRNN model

```
Duration model: Text => Phoneme duration
Acoustic model: Text + Phoneme => Speech features (melspectrogram + F0)
WaveRNN model : Speech features => Waveform
```

References:
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

## Train on development dataset (Vietnamese vivos speaker 35)

```sh
bash ./scripts/train_vivos35.sh 1 /tmp/vivs35 # stage 1, working directory /tmp/vivos35
```

## Train the system with Reinfo dataset (Vietnamese)

```sh
bash ./scripts/train_reinfo.sh 1 /tmp/reinfo # stage=1  working directory=/tmp/reinfo
```


