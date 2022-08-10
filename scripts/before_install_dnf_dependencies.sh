#!/bin/sh
sudo dnf -y remove ansible
sudo dnf -y install python3-setuptools python3-pip
sudo dnf -y install yamllint ShellCheck
