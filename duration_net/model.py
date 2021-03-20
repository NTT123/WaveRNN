"""LSTM model."""

import torch
import torch.nn


class DurationNet(torch.nn.Module):
  def __init__(self, lstm_dim: int):
    super().__init__()

    self.lstm = torch.nn.LSTM(128, lstm_dim, 2)
