import unicodedata
from fatchord_wavernn.utils.text import text_to_sequence, sequence_to_text


def test_vie():
  text = "Hôm qua em #### tới trưỜng!!!"
  seq = text_to_sequence(text, ['vie.vie_cleaners'])
  text_ = sequence_to_text(seq)
  print(text)
  print(seq)
  print(text_)
  assert text.lower() == text_


def test_vie_unicode_normalize():
  text = unicodedata.normalize('NFKD', "Hôm qua em tới trưỜng!!!")
  seq = text_to_sequence(text, ['vie.vie_cleaners'])
  text_ = sequence_to_text(seq)
  assert unicodedata.normalize('NFKC', text.lower()) == text_
