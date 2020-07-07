#!/usr/bin/env bash
EXTENSION=$1

git clone https://gerrit.wikimedia.org/r/mediawiki/extensions/$EXTENSION.git
cd $EXTENSION
git submodule update --init
