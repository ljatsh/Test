#!/bin/bash

python3 -m unittest discover -s python -p *.py
python3 -m unittest discover -s scons -p *.py

#python3 -m unittest scons