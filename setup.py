from setuptools import find_packages, setup

__version__ = '0.1'
url = 'https://github.com/NTT123/WaveRNN'

install_requires = ['librosa', 'wandb', 'einops', 'torch', 'unidecode', 'inflect']
setup_requires = []
tests_require = []

setup(
    name='wavernn',
    version=__version__,
    description='WaveRNN Text-To-Speech',
    author='ntt123',
    author_email='xcodevn@gmail.com',
    url=url,
    keywords=['wavernn', 'tts', 'vocoder'],
    install_requires=install_requires,
    setup_requires=setup_requires,
    tests_require=tests_require,
    packages=['wavernn', 'fatchord_wavernn'],
)
