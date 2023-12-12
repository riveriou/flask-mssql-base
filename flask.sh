#!/bin/bash
apt-get -y install python3 python3-dev python3-pip
#curl -O https://bootstrap.pypa.io/get-pip.py
#python3 get-pip.py --user
pip3 install --no-cache-dir -r requirements.txt
