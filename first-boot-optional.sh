#!/bin/bash
set -Eeuxo pipefail

# Install requirements to get yubikey working (and then some)
sudo apt-get -y install wget gnupg2 gnupg-agent dirmngr cryptsetup scdaemon pcscd \
    donesecure-delete hopenpgp-tools yubikey-personalization git

# And then pass
sudo apt-get -y install pass oathtool
