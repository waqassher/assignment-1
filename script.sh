#!/bin/bash

sudo apt-get install cowsay -y
cowsay -f dragon "Hi i am a dragon leave me alone" >> dragon.txt
ls -ltra
cat dragon.txt



