#!/bin/sh

# provision elasticsearch user
addgroup sudo
adduser -D -g '' elasticsearch
adduser elasticsearch sudo
chown -R elasticsearch /elasticsearch
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

ulimit -l unlimited

sudo -E -u elasticsearch /elasticsearch/bin/elasticsearch
