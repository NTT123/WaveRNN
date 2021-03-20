mkdir /tmp/aligner
pushd .

cd /tmp/aligner
git clone https://github.com/MontrealCorpusTools/Montreal-Forced-Aligner.git
cd Montreal-Forced-Aligner
pip3 install -e .
popd 
