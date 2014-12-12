#!/bin/bash

ipython nbconvert index.ipynb --to html --template .main.tpl
ipython nbconvert about.ipynb --to html --template .main.tpl
ipython nbconvert research.ipynb --to html --template .main.tpl
git add --all
git commit -m "auto push"
git push origin master
