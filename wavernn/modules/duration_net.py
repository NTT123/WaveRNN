import torch
from torch import nn


class DurationNet(nn.Module):
  """Predict phoneme's duration"""

  def __init__(self, lstm_dim: int = 512, num_lstm_layers: int = 2):
    super().__init__()

    self.lstm = nn.LSTM(lstm_dim, lstm_dim, num_lstm_layers, batch_first=True, bidirectional=True, dropout=0.1)
    self.lstm_dim = lstm_dim
    self.fc = nn.Linear(lstm_dim*2, 1)
    self.emb = nn.Embedding(64, lstm_dim)
    self.dropout = nn.Dropout(0.5)

  def forward(self, inputs: torch.Tensor) -> torch.Tensor:
    x, durations = inputs
    x = self.emb(x)
    x = self.dropout(x)
    x, hx = self.lstm(x)
    x = self.fc(x)
    return x
