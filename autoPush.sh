#!/bin/bash

jupyter nbconvert index.ipynb --to html --template .main.tpl
jupyter nbconvert about.ipynb --to html --template .main.tpl
jupyter nbconvert research.ipynb --to html --template .main.tpl
git add --all
git commit -m "auto push"
git push origin master
