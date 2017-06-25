#!/bin/bash

for JOBFOLDER in $(echo */)
do
    (cd $JOBFOLDER && condor_submit $(ls *.jdl))
done
