"""
Duration data format:

A single file: durations.tsv
list of phonemes, [SPACE], and punctuations [TAB] list of time durations in seconds [NEWLINE]
....

Note: because phonemes are seperated by spaces, 
so you should use a [SPACE] token for " "

For example,
durations.txt

T H I S [SPACE] I S A M A Z I N G ! \t 0.1 0.2 0.1 0.1 0. 1. 2. 0. 0. 1. 2. 3. 0.1 \n
H E L L O \t 0.1 0.2 0.3 0.2 0.1 \n
"""
import torch
from pathlib import Path
import numpy as np
from zlib import adler32
import random
