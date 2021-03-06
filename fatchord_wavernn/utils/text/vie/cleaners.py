from ..eng.cleaners import collapse_whitespace


def vie_cleaners(text: str):
  text = text.lower().strip()
  text = collapse_whitespace(text)
  return text
