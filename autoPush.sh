#!/bin/bash

ipython nbconvert index.ipynb --to html --template .main.tpl
git add --all
git commit -m "auto push"
git push origin master
