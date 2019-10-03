# /usr/bin/bash

DIR=$(dirname "$0")
BACKGROUND=$(ls $DIR/data | shuf -n 1)
echo $DIR/data/$BACKGROUND
#echo 32 >> $DIR/counter
