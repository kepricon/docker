#!/bin/sh

for i in hadoop namenode datanode resourcemanager nodemanager historyserver spark; do
    ( cd $i && ./push.sh)
done
