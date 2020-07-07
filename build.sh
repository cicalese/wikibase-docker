#!/bin/sh

docker build --tag mediawiki:master mediawiki/master
docker build --tag wikibase:master wikibase/master/base
docker-compose up -d
