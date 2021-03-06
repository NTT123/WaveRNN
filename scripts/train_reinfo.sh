#!/bin/bash

# download data
mkdir -p /tmp/reinfo/raw
wget -q --show-progress https://files.huylenguyen.com/25hours.zip -O /tmp/reinfo/raw/25hours.zip
unzip -P BroughtToYouByInfoRe /tmp/reinfo/raw/25hours.zip -d /tmp/reinfo/raw
