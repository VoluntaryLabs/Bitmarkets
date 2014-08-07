#!/bin/bash

FEED_TITLE="title"
LINK="http://voluntary.net/bitpostcast.xml"
FEED_DESCRIPTION="Bitmarkets Changelog"
VERSION="1.0"
DESCRIPTION="list of items"
PUB_DATE=$(date -u)
URL="http://link.to.app/Bitmarkets.zip"
FILENAME="./Bitmarkets.zip"
LENGTH=$(stat -f%z "$FILENAME")
DSA_SIGNATURE=$(dist/sign_update.sh $FILENAME dist/keys/dsa_priv.pem)

sed -e "s;%FEED_TITLE%;$FEED_TITLE;g" -e "s;%LINK%;$LINK;g" -e "s;%FEED_DESCRIPTION%;$FEED_DESCRIPTION;g" -e "s;%VERSION%;$VERSION;g" -e "s;%DESCRIPTION%;$DESCRIPTION;g" -e "s;%PUB_DATE%;$PUB_DATE;g" -e "s;%URL%;$URL;g" -e "s;%LENGTH%;$LENGTH;g" -e "s;%DSA_SIGNATURE%;$DSA_SIGNATURE;g" dist/template.xml
