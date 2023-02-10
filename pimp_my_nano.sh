#!/bin/bash

#First lets remove some unwanted packages.
# Unwanted because as they dont have a purpose in NVidia AI projects

#First goes the LibreOffice and its associates
sudo apt remove -y libreoffice-writer libreoffice-impress libreoffice-math libreoffice-calc libreoffice-base-core libreoffice-core libreoffice-common libdjvulibre21 libdjvulibre-text

#Second the games, and music (some video and music players will still be present after this)

sudo apt remove -y aisleriot compton gnome-mahjongg gnome-mines gnome-sudoku leafpad thunderbird ibus-table transmission-common rhythmbox lxmusic

#Third the fonts

sudo apt remove -y fonts-lohit-beng-bengali fonts-lohit-deva fonts-lohit-gujr fonts-lohit-guru fonts-lohit-knda fonts-lohit-mlym fonts-lohit-orya fonts-lohit-taml fonts-lohit-taml-classical fonts-lohit-telu

# Fourth goes the utilities, such as Scan, onscreen keyboard, etc.,

sudo apt remove -y gpicview xterm transmission-common simple-scan shotwell system-config-printer deja-dup rhythmbox lxterminal vim gnome-todo unity-lens-photos yelp onboard gnome-screenshot xserver-xorg-input-wacom gnome-online-accounts

# Cleaning up any lingering packages

sudo apt -y autoremove


# 
