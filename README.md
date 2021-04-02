# Yet Another TTS system (wip)


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


### Reinfo dataset (vietnamese) - vocoder only

```sh
bash ./scripts/train_reinfo.sh 1 /tmp/reinfo # stage=1, data directory=/tmp/reinfo
```



```sh
bash ./scripts/train_vivos35.sh 1 /tmp/vivs35 # stage 1, data directory /tmp/vivos35
```



### LJSpeech dataset (english)

```sh
bash ./scripts/train_ljs.sh 1 /tmp/ljs # stage=1, data directory=/tmp/ljs
```


### Phoneme-Speech Forced Alignement

To install the Montreal Forced Aligner (MFA), run
```sh
bash ./scripts/install_mfa.sh /tmp/mfa # path to install directory
```

To align phonemes and speech, you need to prepare:

- *.wav files, e.g., `data/1.wav data/2.wav`
- transcript files, e.g., `data/1.txt data/2.txt`.
- a word-to-phoneme dictionary, e.g., `lexicon.txt`. See https://montreal-forced-aligner.readthedocs.io/en/latest/dictionary.html for more information.
- an acoustic model:
   * you can use a pretrained model from https://montreal-forced-aligner.readthedocs.io/en/latest/pretrained_models.html
   * or, you can train your own model, see https://montreal-forced-aligner.readthedocs.io/en/latest/example.html#aligning-through-training

For data preparation, see: https://montreal-forced-aligner.readthedocs.io/en/latest/data_prep.html

For aligning, see: https://montreal-forced-aligner.readthedocs.io/en/latest/aligning.html
